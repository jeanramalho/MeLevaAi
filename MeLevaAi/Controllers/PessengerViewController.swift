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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        
        self.title = "MeLevaAí - Passageiro"
        
        viewModel.setupViewModel()
        
        setupMap()
        setupContentView()
        setupNavigationBar()
        setHierarchy()
        setConstraints()
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
                
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
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
            self.contentView.callCarButton.backgroundColor = UIColor.red
            self.contentView.callCarButton.setTitleColor(UIColor.white, for: .normal)
            
            self.contentView.callCarButton.addTarget(self, action: #selector(cancellACar), for: .touchUpInside)
            
        } else {
            
            self.contentView.callCarButton.setTitle("Solicitar Carro", for: .normal)
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
        
        requestViewModel.cancellCarRequest { [weak self] success in
            
            guard let self = self else {return}
                
            if success {
                    self.updateCarCallButton()
                }
        }
    }
    
}
