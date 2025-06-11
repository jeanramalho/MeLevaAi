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
    
    
    // Quando o motorista clica em "Confirmar Carona"
    @objc private func didTapConfirmRequest() {
        // Aceita corrida enviando dados do motorista para o firebase
        self.requestViewModel.updateConfirmedRequest(passengerEmail: self.passenger.email) { [weak self] success in
            
            guard let self = self else {return}
            
            if success {
                
                //MARK: Exibi o caminho do passageiro no mapa
                
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
                
            } else {
                
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
