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

class RouteViewController: UIViewController {
    
    private let contentView: RouteView = RouteView()
    private let driver: Driver
    private let passenger: UserRequestModel
    
    private let locationManeger = CLLocationManager()
    
    private let requestId: String
    
    init(driver: Driver, pessenger: UserRequestModel, requestId: String) {
        self.driver = driver
        self.pessenger = pessenger
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
    
    @objc private func didTapConfirmRequest() {
        
    }
}
