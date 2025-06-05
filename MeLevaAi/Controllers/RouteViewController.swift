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
    
    private let locationManeger = CLLocationManager()
    
    private let requestId: String
    
    init(driver: Driver, pessenger: UserRequestModel, requestId: String) {
        self.driver = driver
        self.passenger = pessenger
        self.requestId = requestId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        
        drawRouteBetweenDriverAndPassenger()
        setupLocationManager()
        setupContentView()
        setHierarchy()
        setConstraints()
    }
    
    private func setupContentView(){
        contentView.confirmRequestButton.addTarget(self, action: #selector(didTapConfirmRequest), for: .touchUpInside)
    }
    
    private func setHierarchy(){
        view.addSubview(contentView)
    }
    
    private func setConstraints(){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.setConstraintsToParent(self.view)
    }
    
    private func setupLocationManager(){
        locationManeger.delegate = self
        locationManeger.requestWhenInUseAuthorization()
        // atualização de alta precisão para seguir a rota
        locationManeger.desiredAccuracy = kCLLocationAccuracyBest
        locationManeger.startUpdatingLocation()
    }
    
    // Desenha rota inicial(estática) entre as coordenadas no motorista e do passageiro
    private func drawRouteBetweenDriverAndPassenger(){
        guard
            let passengerCoord = passenger.coordinate,
            let driverCoord = driver.coordinate
        else {
            print("Coordenadas inválidas para desenhar rota")
                  return
        }
        
        let srcPlaceMark = MKPlacemark(coordinate: driverCoord)
        let dstPlaceMark = MKPlacemark(coordinate: passengerCoord)
        
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: srcPlaceMark)
        req.destination = MKMapItem(placemark: dstPlaceMark)
        req.transportType = .automobile
        
        let directions = MKDirections(request: req)
        directions.calculate { [weak self] response, error in
            guard let self = self, let route = response?.routes.first else {
                print("Erro ao calcular rota: \(error?.localizedDescription ?? "sem detalhes").")
                                return
            }
            
        // Exibe a rota no mapa
            self.contentView.routeMapView.addOverlay(route.polyline)
        // Ajusta zoom para mostrar toda a rota
            self.contentView.routeMapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 150, right: 50), animated: true)
        }

    }
    // Quando o motorista clicar em aceitar carona
    @objc private func didTapConfirmRequest() {
        // Mudar o nó no firebase, criando o nó de viagens que vai ter os dados do motorista e passageiro
        // Remover a requisição que estava em requests
        // Publicar a localização do motorista em viagens/motorista
        
        let database = Database.database().reference()
        let rootRequisicoes = database.child("requisicoes").child(requestId)
        let rootViagens = database.child("viagens").child(requestId)
        
        // limpa o nó de requisicoes
        rootRequisicoes.removeValue { error, _ in
            if let error = error {
                print("❌ Erro ao remover requisição: \(error.localizedDescription)")
                            return
            }
            
            let passengerDict: [String: Any] = [
                "email": self.passenger.email,
                "nome": self.passenger.nome,
                "latitude": self.passenger.latitude,
                "longitude": self.passenger.longitude
            ]
            
            // Dados iniciais do motorista
            guard let driverCoord = self.driver.coordinate else {return}
            let driverDict: [String: Any] = [
                "email": self.driver.email,
                "nome": self.driver.nome,
                "latitude": "\(driverCoord.latitude)",
                "longitude": "\(driverCoord.longitude)"
            ]
            
            // Monta o dicionário da viagem
            let viagemDict: [String: Any] = [
                "motorista": driverDict,
                "passageiro": passengerDict,
                "status": "em_andamento"
            ]
            
            rootViagens.setValue(viagemDict) { error, _ in
                if let error = error {
                    print("❌ Erro ao criar viagem: \(error.localizedDescription)")
                    return
                }
                // Atualiza a UI e esconde botão
                DispatchQueue.main.async {
                    self.contentView.confirmRequestButton.isHidden = true
                }
            }
            
        }
  
        
    }
}

extension RouteViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let loc = locations.last else {return}
        
        // atualizando o mapa para mostrar onde o motorista está em tempo real
        let circle = MKCircle(center: loc.coordinate, radius: 5)
        contentView.routeMapView.removeOverlays(contentView.routeMapView.overlays.filter { $0 is MKCircle})
        contentView.routeMapView.addOverlay(circle)
        
        // Publica a nova localização do motorista no firebase
        let driverRef = Database.database()
            .reference()
            .child("requisicoes")
            .child(requestId)
            .child("viagens")
        
        let latitudeStr = "\(loc.coordinate.latitude)"
        let longitudeStr = "\(loc.coordinate.longitude)"
        
        driverRef.child("latitude").setValue(latitudeStr)
        driverRef.child("longitude").setValue(longitudeStr)
        
    }
}

extension RouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        
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
