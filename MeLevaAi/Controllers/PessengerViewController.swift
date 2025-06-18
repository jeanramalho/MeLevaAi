//
//  PessengerViewController.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 27/04/25.
//
import Foundation
import UIKit
import MapKit

class PessengerViewController: UIViewController {
    
    private let contentView: PessengerView = PessengerView()
    private let authService = Authentication()
    private let viewModel = LocationViewModel()
    private let requestViewModel = RequestsViewModel()
    
    private var driverOnTheWay: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkIfCarIsRequested()
        self.updateMap()
    }
    
    
    private func setup(){
        
        self.title = "MeLevaAí - Passageiro"
        
        viewModel.setupViewModel()
        
        updateMap()
        checkIfCarIsRequested()
        setupMap()
        setupContentView()
        setupNavigationBar()
        setHierarchy()
        setConstraints()
    }
    
    private func checkIfCarIsRequested(){
        
        self.requestViewModel.checkIfHaveRequests { [weak self] hasARequest in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.updateCarCallButton()
            }
        }
    }
    
    private func setupContentView(){
        
        let logOutButton = UIBarButtonItem(title: "< Sair",
                                           style: .plain,
                                           target: self,
                                           action: #selector(logOutAccount))
        
        self.navigationItem.leftBarButtonItem = logOutButton
        
        let callCarButton = contentView.callCarButton
        callCarButton.addTarget(self, action: #selector(getACar), for: .touchUpInside)
    }
    
    private func setupMap(){
        
        let mapView = contentView.mapView
        mapView.showsUserLocation = true
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        viewModel.onLocationUpdate = { [weak self] coordinate in
            guard let self = self else {return}
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    private func updateMap(){
        
        
        self.requestViewModel.updatingRequest {[weak self] success, distance in
            
            guard let self = self, let realDistance = distance else {return}
            
            if success {
                
                DispatchQueue.main.async {
                    let callCarButton = self.contentView.callCarButton
                    callCarButton.backgroundColor = .green
                    callCarButton.setTitleColor(.white, for: .normal)
                    callCarButton.setTitle(String(format: "Motorista a %.2f km", realDistance), for: .normal)
                    callCarButton.removeTarget(nil, action: nil, for: .allEvents)
                    
                    self.showDriverOnView()
                }
                
            }
        }
        
    }
    
    private func showDriverOnView() {
        
        self.driverOnTheWay = true
        
        let map = self.contentView.mapView
        
        // Exibe passageiro e motorista no mapa
        
        // 1 - remove todas as anotações
        map.removeAnnotations(map.annotations)
        
        // 2 - cria e adiciona a anotação do motorista
        self.requestViewModel.createDriverAndPassengerAnnotation { driverAnnotation, passengerAnnotation in
            
            if let driverAnnotation = driverAnnotation,
               let passengerAnnotation = passengerAnnotation {
                
                map.addAnnotation(driverAnnotation)
                map.addAnnotation(passengerAnnotation)
                
                // 3 - Define região a ser exibida
                let region = MKCoordinateRegion(center: passengerAnnotation.coordinate , latitudinalMeters: 500, longitudinalMeters: 500)
                map.setRegion(region, animated: true)
                
            }

        }
        
      
    }
    
    private func setHierarchy(){
        
        view.addSubview(contentView)
    }
    
    private func setConstraints(){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.setConstraintsToParent(self.view)
    }
    
    private func updateCarCallButton(){
        
        let callCarButton = contentView.callCarButton
        callCarButton.removeTarget(nil, action: nil, for: .allEvents)
        
        if requestViewModel.isCarCalled {
            
            self.contentView.callCarButton.setTitle("Cancelar Carona", for: .normal)
            self.contentView.callCarButton.backgroundColor = .systemRed
            self.contentView.callCarButton.setTitleColor(UIColor.white, for: .normal)
            self.contentView.callCarButton.addTarget(self, action: #selector(cancellACar), for: .touchUpInside)
            
        } else {
            
            self.contentView.callCarButton.setTitle("Pedir Carona", for: .normal)
            self.contentView.callCarButton.backgroundColor = Colors.darkSecondary
            self.contentView.callCarButton.setTitleColor(Colors.defaultYellow, for: .normal)
            self.contentView.callCarButton.addTarget(self, action: #selector(getACar), for: .touchUpInside)
            
        }
    }
    
    @objc private func logOutAccount(){
        authService.logOut { auth in
            
            let loginViewController = LoginViewController()
            
            if auth == false {
                self.navigationController?.setViewControllers([loginViewController], animated: true)
            }
        }
    }
    
    @objc private func getACar(){
        print("Chamando um carro")
        
        guard !requestViewModel.isCarCalled else {
            let alert = UIAlertController(title: "Já existe uma corrida pendente",
                                          message: "Cancele ou conclua sua corrida atual antes de pedir outra.",
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        guard let cordinate = viewModel.currentLocation else {
            print("Localização não disponível!")
            return
        }
            self.requestViewModel.userLocation = cordinate
            
            self.requestViewModel.requestACar { [weak self] isCarCalled in
                
            guard let self = self else {return}
                
                if isCarCalled {
                    self.updateCarCallButton()
                }
            }
    }
    
    @objc private func cancellACar(){
        
        guard let requestId = self.requestViewModel.currentRequestId else {return}
        
        requestViewModel.cancellCarRequest { [weak self] success in
            
            guard let self = self else {return}
                
            if success {
                
                DispatchQueue.main.async {
                    self.updateCarCallButton()
                }
                    
                }
        }
    }
    
}
