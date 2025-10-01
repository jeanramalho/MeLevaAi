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
        self.setupRideCompletionObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove observadores para evitar vazamentos de memória
        self.requestViewModel.removeRideCompletionObserver()
    }
    
    
    private func setup(){
        
        self.title = "MeLevaAí - Passageiro"
        
        viewModel.setupViewModel()
        
        hideKeyboard(self, contentView: self.contentView)
        
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
        
        // Só atualiza o mapa se a corrida foi aceita pelo motorista
        self.requestViewModel.updatingRequest {[weak self] success, distance in
            
            guard let self = self else { return }
            
            // Só procede se houve sucesso E há distância (corrida aceita)
            if success, let realDistance = distance {
                
                DispatchQueue.main.async {
                    let callCarButton = self.contentView.callCarButton
                    callCarButton.backgroundColor = .green
                    callCarButton.setTitleColor(.white, for: .normal)
                    callCarButton.setTitle(String(format: "Motorista a %.2f km", realDistance), for: .normal)
                    callCarButton.removeTarget(nil, action: nil, for: .allEvents)
                    
                    self.showDriverOnView()
                }
                
            }
            // Se não há sucesso ou distância, mantém o estado atual (não muda nada)
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
                
                // Calcula valor para exibição otimizada do passageiro e motorista na tela
                let diferenceLatitude = abs(passengerAnnotation.coordinate.latitude - driverAnnotation.coordinate.latitude) * 300000
                
                let diferenceLongitude = abs(passengerAnnotation.coordinate.longitude - driverAnnotation.coordinate.longitude) * 300000
                
                // 3 - Define região a ser exibida
                let region = MKCoordinateRegion(center: passengerAnnotation.coordinate , latitudinalMeters: diferenceLatitude, longitudinalMeters: diferenceLongitude)
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
        
        guard let destinyLocation = self.contentView.destinyLocationTextField.text as String? else {return}
        
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
        
        if destinyLocation != "" {
            
            CLGeocoder().geocodeAddressString(destinyLocation) { local, error in
                if error == nil,
                   let dadosLocal = local?.first {
                    
                    if dadosLocal.thoroughfare != nil,
                       dadosLocal.subThoroughfare != nil,
                       dadosLocal.subLocality != nil,
                       dadosLocal.locality != nil,
                       dadosLocal.postalCode != nil {
                        
                        guard let rua = dadosLocal.thoroughfare else {return}
                        guard let numero = dadosLocal.subThoroughfare else {return}
                        guard let bairro = dadosLocal.subLocality else {return}
                        guard let cidade = dadosLocal.locality else {return}
                        guard let cep = dadosLocal.postalCode else {return}
                        
                        let completeAdress = "rua: \(rua), n:\(numero), bairro: \(bairro) - \(cidade) - cep: \(cep)"
                        
                        if let destinyLatitude = dadosLocal.location?.coordinate.latitude,
                           let destinyLongitude = dadosLocal.location?.coordinate.longitude {
                            
                            let destinyCoordinate = CLLocationCoordinate2D(latitude: destinyLatitude, longitude: destinyLongitude)
                            
                            let alert = UIAlertController(title: "Confirme o endereço de destino",
                                                          message: completeAdress,
                                                          preferredStyle: .alert)
                            let cancellAction = UIAlertAction(title: "CANCELAR", style: .cancel, handler: nil)
                            let confirmAction = UIAlertAction(title: "OK", style: .default) { alertAction in
                                
                                self.requestViewModel.userLocation = cordinate
                                self.requestViewModel.destinyLocation = destinyCoordinate
                                
                                self.requestViewModel.requestACar { [weak self] isCarCalled in
                                    
                                guard let self = self else {return}
                                    
                                    if isCarCalled {
                                        self.updateCarCallButton()
                                    }
                                }
                            }
                            
                            alert.addAction(cancellAction)
                            alert.addAction(confirmAction)
                            self.present(alert, animated: true)
                        }
                    }
                    
                    
                    
                }
            }
            
           
            
        } else {
            let alert = UIAlertController(title: "Digite o endereço de destino!",
                                          message: "Digite o endereço de destino antes de chamar um carro!",
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
            return
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
    
    // MARK: - Observador de Finalização de Corrida
    
    /// Configura o observador para detectar quando a corrida é finalizada
    private func setupRideCompletionObserver() {
        
        // Obtém o email do usuário logado
        authService.getReqUserData { [weak self] user in
            
            guard let self = self,
                  let user = user else { return }
            
            // Configura o observador para notificar quando a corrida for finalizada
            self.requestViewModel.observeRideCompletion(passengerEmail: user.email) { [weak self] in
                self?.handleRideCompletion()
            }
        }
    }
    
    /// Manipula a finalização da corrida - reseta o estado do passageiro
    private func handleRideCompletion() {
        
        print("🎉 Corrida finalizada! Resetando estado do passageiro...")
        
        // Reseta o estado visual
        resetPassengerState()
        
        // Mostra alerta de corrida concluída
        showRideCompletedAlert()
    }
    
    /// Reseta o estado do passageiro para permitir nova corrida
    private func resetPassengerState() {
        
        // Limpa o campo de destino
        contentView.destinyLocationTextField.text = ""
        
        // Reseta o estado do motorista a caminho
        driverOnTheWay = false
        
        // Remove todas as anotações do mapa
        contentView.mapView.removeAnnotations(contentView.mapView.annotations)
        
        // Atualiza o botão para o estado inicial
        updateCarCallButton()
        
        // Reseta a visualização do mapa para a localização atual
        resetMapView()
        
        print("✅ Estado do passageiro resetado com sucesso")
    }
    
    /// Reseta a visualização do mapa para a localização atual
    private func resetMapView() {
        
        guard let currentLocation = viewModel.currentLocation else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: currentLocation, span: span)
        contentView.mapView.setRegion(region, animated: true)
    }
    
    /// Mostra alerta de corrida concluída
    private func showRideCompletedAlert() {
        
        let alert = UIAlertController(
            title: "Corrida Concluída! 🎉",
            message: "Sua corrida foi finalizada com sucesso! Você pode pedir uma nova corrida quando quiser.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
}
