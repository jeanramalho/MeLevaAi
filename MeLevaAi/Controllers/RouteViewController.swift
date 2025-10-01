//
//  RouteViewController.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 30/05/25.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import FirebaseDatabase

class RouteViewController: UIViewController {
    
    private let contentView: RouteView = RouteView()
    private let requestViewModel = RequestsViewModel()
    
    private let driver: Driver
    private let passenger: UserRequestModel
    
    private let locationManager = CLLocationManager()
    private let requestId: String
    
    
    init(driver: Driver, pessenger: UserRequestModel, requestId: String) {
        self.driver = driver
        self.passenger = pessenger
        self.requestId = requestId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(driver:passenger:requestId:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Verifica o status da requisição e configura o botão adequadamente
        checkRequestStatusAndUpdateButton()
    }
    
    private func setup() {
     
        setupLocationManager()
        setupContentView()
        setHierarchy()
        setConstraints()
    }
    
    private func setupContentView() {
        // O botão "Confirmar Carona"
        contentView.confirmRequestButton.addTarget(
            self,
            action: #selector(didTapConfirmRequest),
            for: .touchUpInside
        )
        
        // Atribui o delegate do mapView para desenhar círculos/linhas
        contentView.routeMapView.delegate = self
    }
    
    private func setHierarchy() {
        view.addSubview(contentView)
    }
    
    private func setConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.setConstraintsToParent(self.view)
    }
    
    private func setupLocationManager() {
        
        let map = self.contentView.routeMapView
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        guard let passengerCoord = self.passenger.coordinate else {return}
        
        let region = MKCoordinateRegion(center: passengerCoord, latitudinalMeters: 200, longitudinalMeters: 200)
        // mostra região do passageiro ao abrir o mapa
        map.setRegion(region, animated: true)
        
        // Mostrar nome do passageiro no mapa
        let annotationPassegenger = MKPointAnnotation()
        annotationPassegenger.coordinate = passengerCoord
        annotationPassegenger.title = self.passenger.nome
        map.addAnnotation(annotationPassegenger)
    }
    
    // Verifica o status da requisição no Firebase e atualiza o botão adequadamente
    private func checkRequestStatusAndUpdateButton() {
        
        let database = Database.database().reference()
        let requestRef = database.child("requisicoes").child(requestId)
        
        requestRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            
            guard let self = self,
                  let value = snapshot.value as? [String: Any],
                  let status = value["status"] as? String else {
                return
            }
            
            DispatchQueue.main.async {
                // Atualiza o botão baseado no status da requisição
                if status == "aceita" {
                    self.contentView.confirmRequestButton.setTitle("Corrida Aceita", for: .normal)
                    self.contentView.confirmRequestButton.backgroundColor = .systemRed
                    // Mantém o botão habilitado para permitir abrir o Maps novamente
                    self.contentView.confirmRequestButton.isEnabled = true
                } else {
                    self.contentView.confirmRequestButton.setTitle("Confirmar Carona", for: .normal)
                    self.contentView.confirmRequestButton.backgroundColor = Colors.darkSecondary
                    self.contentView.confirmRequestButton.isEnabled = true
                }
            }
        }
    }
    
    // Abre o Maps com a rota para o passageiro
    private func openMapsWithRoute() {
        
        // Cria uma instancia CLLocation com as coordenadas do passageiro
        guard let passengerLati = self.passenger.coordinate?.latitude as? Double else {return}
        guard let passengerLong = self.passenger.coordinate?.longitude as? Double else {return}
        
        let passengerCLL = CLLocation(latitude: passengerLati, longitude: passengerLong)
        
        CLGeocoder().reverseGeocodeLocation(passengerCLL) { local, error in
            
            if let error = error {
                
                print("Impossível criar trajeto: \(error.localizedDescription)")
                
            } else {
                
                if let localData = local?.first {
                    let placeMark = MKPlacemark(placemark: localData)
                    let mapItem = MKMapItem(placemark: placeMark)
                    mapItem.name = self.passenger.nome
                    
                    // Define opções de como o trajeto será feito - no caso do app será dirigindo
                    let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    // Abre rota no maps
                    mapItem.openInMaps(launchOptions: options)
                }
                
            }
        }
    }
    
    // Quando o motorista clica em "Confirmar Carona" ou "Corrida Aceita"
    @objc private func didTapConfirmRequest() {
        
        // Verifica se a corrida já foi aceita
        if self.contentView.confirmRequestButton.title(for: .normal) == "Corrida Aceita" {
            // Se já foi aceita, apenas abre o Maps
            self.openMapsWithRoute()
            return
        }
        
        // Se ainda não foi aceita, aceita a corrida primeiro
        guard let driverCoordinate = self.driver.coordinate else {return}
        
        // Aceita corrida enviando dados do motorista para o firebase
        self.requestViewModel.updateConfirmedRequest(passengerEmail: self.passenger.email, driverCoordinate: driverCoordinate) { [weak self] success in
            
            guard let self = self else {return}
            
            if success {
                
                // Atualiza o botão para mostrar que a corrida foi aceita
                self.contentView.confirmRequestButton.setTitle("Corrida Aceita", for: .normal)
                self.contentView.confirmRequestButton.backgroundColor = .systemRed
                // Mantém o botão habilitado para permitir abrir o Maps novamente
                self.contentView.confirmRequestButton.isEnabled = true
                
                // Abre o Maps com a rota para o passageiro
                self.openMapsWithRoute()
                
            } else {
                print("❌ Erro ao aceitar corrida")
            }
        }
    }
}

// MARK: – CLLocationManagerDelegate
extension RouteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}

// MARK: –– MKMapViewDelegate
extension RouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 4
            return renderer
        }
        if let circle = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circle)
            renderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.6)
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
