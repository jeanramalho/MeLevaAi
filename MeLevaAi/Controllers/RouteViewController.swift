//
//  RouteViewController.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 30/05/25.
//
import Foundation
import UIKit
import CoreLocation

class RouteViewController: UIViewController {
    
    private let contentView: RouteView = RouteView()
    private let driver: Driver
    private let pessenger: UserRequestModel
    
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
    
}
