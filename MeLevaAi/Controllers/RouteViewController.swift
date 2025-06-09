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
     
        drawRouteBetweenDriverAndPassenger()
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
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // Desenha a rota inicial (quando o motorista ainda não aceitou)
    private func drawRouteBetweenDriverAndPassenger() {
        guard
            let passengerCoord = passenger.coordinate,
            let driverCoord = driver.coordinate
        else {
            print("Coordenadas inválidas para desenhar rota")
            return
        }
        
        let srcPlacemark = MKPlacemark(coordinate: driverCoord)
        let dstPlacemark = MKPlacemark(coordinate: passengerCoord)
        
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: srcPlacemark)
        req.destination = MKMapItem(placemark: dstPlacemark)
        req.transportType = .automobile
        
        let directions = MKDirections(request: req)
        directions.calculate { [weak self] response, error in
            guard
                let self = self,
                let route = response?.routes.first
            else {
                print("Erro ao calcular rota: \(error?.localizedDescription ?? "sem detalhes")")
                return
            }
            
            // Adiciona a polyline da rota no mapa
            self.contentView.routeMapView.addOverlay(route.polyline)
            
            // Ajusta o zoom para cobrir toda a rota
            self.contentView.routeMapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 150, right: 50),
                animated: true
            )
        }
    }
    
    // Quando o motorista clica em "Confirmar Carona"
    @objc private func didTapConfirmRequest() {
        let database      = Database.database().reference()
        let requisicoesRef = database.child("requisicoes").child(requestId)
        let viagensRef     = database.child("viagens").child(requestId)
        
        // Remove a requisição de "/requisicoes/<requestId>"
        requisicoesRef.removeValue { [weak self] error, _ in
            guard let self = self else { return }
            if let error = error {
                print("❌ Erro ao remover requisição: \(error.localizedDescription)")
                return
            }
            
            // Monta dicionário do passageiro
            let passengerDict: [String: Any] = [
                "email": self.passenger.email,
                "nome": self.passenger.nome,
                "latitude": self.passenger.latitude,
                "longitude": self.passenger.longitude
            ]
            
            // Montar dicionário inicial do motorista (com coordenadas atuais)
            guard let driverCoord = self.driver.coordinate else { return }
            let driverDict: [String: Any] = [
                "email": self.driver.email,
                "nome": self.driver.nome,
                "latitude": "\(driverCoord.latitude)",
                "longitude": "\(driverCoord.longitude)"
            ]
            
            // 4) Montar dicionário da viagem inteira
            let viagemDict: [String: Any] = [
                "motorista": driverDict,
                "passageiro": passengerDict,
                "status": "em_andamento"
            ]
            
            // 5) Criar "/viagens/<requestId>" no Firebase
            viagensRef.setValue(viagemDict) { error, _ in
                if let error = error {
                    print("❌ Erro ao criar viagem: \(error.localizedDescription)")
                    return
                }
                
                // 6) Atualiza UI, esconde o botão
                DispatchQueue.main.async {
                    self.contentView.confirmRequestButton.isHidden = true
                }
            }
        }
    }
}

// MARK: – CLLocationManagerDelegate
extension RouteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        
        // Atualiza o mapa com um círculo que representa o motorista
        let circle = MKCircle(center: loc.coordinate, radius: 5)
        // Remove quaisquer círculos antigos antes de adicionar o novo
        let oldCircles = contentView.routeMapView.overlays.filter { $0 is MKCircle }
        contentView.routeMapView.removeOverlays(oldCircles)
        contentView.routeMapView.addOverlay(circle)
        
        // Publica no nó correto no firebase "/viagens/<requestId>/motorista"
        let motoristaRef = Database.database()
            .reference()
            .child("viagens")
            .child(requestId)
            .child("motorista")
        
        let latitudeStr  = "\(loc.coordinate.latitude)"
        let longitudeStr = "\(loc.coordinate.longitude)"
        
        // Atualiza apenas os campos latitude e longitude de dentro de "motorista"
        motoristaRef.child("latitude").setValue(latitudeStr)
        motoristaRef.child("longitude").setValue(longitudeStr)
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
