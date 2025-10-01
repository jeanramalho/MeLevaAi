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
    
    // MARK: - Propriedades para Controle de Estado da Corrida
    private var currentDriverLocation: CLLocationCoordinate2D?
    private var isNearPassenger: Bool = false
    private var isRideInProgress: Bool = false
    private var locationUpdateTimer: Timer?
    
    // MARK: - Propriedades para Anotações do Mapa
    private var driverAnnotation: MKPointAnnotation?
    private var passengerAnnotation: MKPointAnnotation?
    
    
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
        // Inicia o monitoramento de localização em tempo real
        startLocationMonitoring()
        // Configura as anotações iniciais do mapa
        setupInitialMapAnnotations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Para o monitoramento de localização quando sair da tela
        stopLocationMonitoring()
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
    }
    
    // MARK: - Configuração de Anotações do Mapa
    
    /// Configura as anotações iniciais do motorista e passageiro no mapa
    private func setupInitialMapAnnotations() {
        
        guard let passengerCoord = self.passenger.coordinate else { return }
        
        // Remove anotações existentes
        contentView.routeMapView.removeAnnotations(contentView.routeMapView.annotations)
        
        // Cria anotação do passageiro
        passengerAnnotation = MKPointAnnotation()
        passengerAnnotation?.coordinate = passengerCoord
        passengerAnnotation?.title = "Passageiro: \(self.passenger.nome)"
        passengerAnnotation?.subtitle = "Destino: \(self.passenger.destinyCoordinate?.latitude ?? 0), \(self.passenger.destinyCoordinate?.longitude ?? 0)"
        
        // Cria anotação do motorista (será atualizada quando tivermos a localização)
        driverAnnotation = MKPointAnnotation()
        driverAnnotation?.title = "Motorista: \(self.driver.nome)"
        driverAnnotation?.subtitle = "Você"
        
        // Adiciona anotações ao mapa
        if let passengerAnnotation = passengerAnnotation {
            contentView.routeMapView.addAnnotation(passengerAnnotation)
        }
        if let driverAnnotation = driverAnnotation {
            contentView.routeMapView.addAnnotation(driverAnnotation)
        }
        
        // Configura região inicial para mostrar ambos
        let region = MKCoordinateRegion(center: passengerCoord, latitudinalMeters: 2000, longitudinalMeters: 2000)
        contentView.routeMapView.setRegion(region, animated: true)
        
        print("📍 Anotações iniciais configuradas - Passageiro: \(passengerCoord)")
    }
    
    /// Atualiza a posição do motorista no mapa em tempo real
    private func updateDriverAnnotationLocation() {
        
        guard let driverLocation = currentDriverLocation,
              let driverAnnotation = driverAnnotation else { return }
        
        // Atualiza a coordenada da anotação do motorista
        driverAnnotation.coordinate = driverLocation
        
        print("🚗 Localização do motorista atualizada no mapa: \(driverLocation)")
    }
    
    // MARK: - Verificação e Atualização de Status da Requisição
    
    /// Verifica o status da requisição no Firebase e atualiza o botão adequadamente
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
                self.updateButtonBasedOnStatus(status: status)
            }
        }
    }
    
    /// Atualiza o botão baseado no status da requisição
    /// - Parameter status: Status atual da requisição
    private func updateButtonBasedOnStatus(status: String) {
        
        switch status {
        case "pendente":
            // Status inicial - motorista pode aceitar a corrida
            contentView.confirmRequestButton.setTitle("Aceitar Corrida", for: .normal)
            contentView.confirmRequestButton.backgroundColor = Colors.darkSecondary
            contentView.confirmRequestButton.setTitleColor(Colors.defaultYellow, for: .normal)
            contentView.confirmRequestButton.isEnabled = true
            
        case "aceita":
            // Corrida aceita - motorista está a caminho do passageiro
            contentView.confirmRequestButton.setTitle("A Caminho do Passageiro", for: .normal)
            contentView.confirmRequestButton.backgroundColor = .systemGray3
            contentView.confirmRequestButton.setTitleColor(.white, for: .normal)
            contentView.confirmRequestButton.isEnabled = true
            
        case "em_andamento":
            // Corrida em andamento - motorista está levando o passageiro ao destino
            contentView.confirmRequestButton.setTitle("Finalizar Corrida", for: .normal)
            contentView.confirmRequestButton.backgroundColor = .systemRed
            contentView.confirmRequestButton.setTitleColor(.white, for: .normal)
            contentView.confirmRequestButton.isEnabled = true
            isRideInProgress = true
            
        case "concluida":
            // Corrida concluída - botão desabilitado
            contentView.confirmRequestButton.setTitle("Corrida Concluída", for: .normal)
            contentView.confirmRequestButton.backgroundColor = .systemGreen
            contentView.confirmRequestButton.setTitleColor(.white, for: .normal)
            contentView.confirmRequestButton.isEnabled = false
            
        default:
            // Status desconhecido - volta ao estado inicial
            contentView.confirmRequestButton.setTitle("Aceitar Corrida", for: .normal)
            contentView.confirmRequestButton.backgroundColor = Colors.darkSecondary
            contentView.confirmRequestButton.setTitleColor(Colors.defaultYellow, for: .normal)
            contentView.confirmRequestButton.isEnabled = true
        }
    }
    
    // MARK: - Monitoramento de Localização e Proximidade
    
    /// Inicia o monitoramento de localização em tempo real
    private func startLocationMonitoring() {
        // Timer para atualizar localização a cada 10 segundos
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.updateDriverLocationInFirebase()
        }
    }
    
    /// Para o monitoramento de localização
    private func stopLocationMonitoring() {
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
    }
    
    /// Atualiza a localização do motorista no Firebase
    private func updateDriverLocationInFirebase() {
        guard let driverLocation = currentDriverLocation else { return }
        
        requestViewModel.updateDriverLocationInRealTime(requestId: requestId, driverCoordinate: driverLocation) { success in
            if success {
                print("✅ Localização do motorista atualizada no Firebase")
                // Atualiza a anotação do motorista no mapa
                self.updateDriverAnnotationLocation()
                // Verifica proximidade com o passageiro
                self.checkProximityToPassenger()
            } else {
                print("❌ Erro ao atualizar localização do motorista")
            }
        }
    }
    
    /// Verifica se o motorista está próximo do passageiro e atualiza o botão
    private func checkProximityToPassenger() {
        guard let driverLocation = currentDriverLocation,
              let passengerLocation = passenger.coordinate else { return }
        
        let isNear = requestViewModel.isDriverNearPassenger(driverLocation: driverLocation, passengerLocation: passengerLocation)
        
        // Se a proximidade mudou, atualiza o botão
        if isNear != isNearPassenger {
            isNearPassenger = isNear
            
            DispatchQueue.main.async {
                if isNear && !self.isRideInProgress {
                    // Motorista chegou perto do passageiro - muda para "Iniciar Corrida"
                    self.contentView.confirmRequestButton.setTitle("Iniciar Corrida", for: .normal)
                    self.contentView.confirmRequestButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.7)
                    self.contentView.confirmRequestButton.setTitleColor(.white, for: .normal)
                    print("🎯 Motorista próximo do passageiro - botão atualizado para 'Iniciar Corrida'")
                }
            }
        }
    }
    
    // MARK: - Navegação e Rotas
    
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
    
    /// Abre o Maps com rota para o destino da corrida
    private func openMapsWithDestinationRoute() {
        
        guard let destinationCoord = passenger.destinyCoordinate else {
            print("❌ Coordenadas do destino não disponíveis")
            return
        }
        
        let destinationCLL = CLLocation(latitude: destinationCoord.latitude, longitude: destinationCoord.longitude)
        
        CLGeocoder().reverseGeocodeLocation(destinationCLL) { [weak self] placemarks, error in
            
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Erro ao obter endereço do destino: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                let mkPlacemark = MKPlacemark(placemark: placemark)
                let mapItem = MKMapItem(placemark: mkPlacemark)
                mapItem.name = "Destino - \(self.passenger.nome)"
                
                // Define opções de navegação para o destino
                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: options)
                
                print("🗺️ Maps aberto com rota para o destino")
            }
        }
    }
    
    // MARK: - Ações do Botão
    
    /// Ação principal do botão - gerencia diferentes estados da corrida
    @objc private func didTapConfirmRequest() {
        
        let buttonTitle = contentView.confirmRequestButton.title(for: .normal) ?? ""
        
        switch buttonTitle {
        case "Aceitar Corrida":
            // Primeira ação - aceitar a corrida
            acceptRide()
            
        case "A Caminho do Passageiro":
            // Motorista está indo buscar o passageiro - abre Maps
            openMapsWithRoute()
            
        case "Iniciar Corrida":
            // Motorista chegou perto do passageiro - inicia a corrida
            startRide()
            
        case "Finalizar Corrida":
            // Motorista chegou ao destino - finaliza a corrida
            finishRide()
            
        default:
            print("⚠️ Estado do botão não reconhecido: \(buttonTitle)")
        }
    }
    
    /// Aceita a corrida e atualiza o status
    private func acceptRide() {
        guard let driverCoordinate = driver.coordinate else {
            print("❌ Coordenadas do motorista não disponíveis")
            return
        }
        
        requestViewModel.updateConfirmedRequest(passengerEmail: passenger.email, driverCoordinate: driverCoordinate) { [weak self] success in
            
            guard let self = self else { return }
            
            if success {
                DispatchQueue.main.async {
                    // Atualiza o botão para mostrar que está a caminho
                    self.contentView.confirmRequestButton.setTitle("A Caminho do Passageiro", for: .normal)
                    self.contentView.confirmRequestButton.backgroundColor = .systemGray3
                    self.contentView.confirmRequestButton.setTitleColor(.white, for: .normal)
                    
                    // Abre o Maps com a rota para o passageiro
                    self.openMapsWithRoute()
                }
                print("✅ Corrida aceita com sucesso")
            } else {
                print("❌ Erro ao aceitar corrida")
            }
        }
    }
    
    /// Inicia a corrida (muda status para "em_andamento")
    private func startRide() {
        requestViewModel.startRide(requestId: requestId) { [weak self] success in
            
            guard let self = self else { return }
            
            if success {
                DispatchQueue.main.async {
                    // Atualiza o botão para mostrar que está em andamento
                    self.contentView.confirmRequestButton.setTitle("Finalizar Corrida", for: .normal)
                    self.contentView.confirmRequestButton.backgroundColor = .systemRed
                    self.contentView.confirmRequestButton.setTitleColor(.white, for: .normal)
                    self.isRideInProgress = true
                    
                    // Abre o Maps com rota para o destino
                    self.openMapsWithDestinationRoute()
                }
                print("🚗 Corrida iniciada - rota para destino aberta")
            } else {
                print("❌ Erro ao iniciar corrida")
            }
        }
    }
    
    /// Finaliza a corrida e salva no histórico
    private func finishRide() {
        
        // Prepara dados da corrida para salvar no histórico
        let rideData: [String: Any] = [
            "passageiroNome": passenger.nome,
            "passageiroEmail": passenger.email,
            "origemLatitude": passenger.latitude,
            "origemLongitude": passenger.longitude,
            "destinoLatitude": passenger.destinyLatitude,
            "destinoLongitude": passenger.destinyLongitude,
            "motoristaNome": driver.nome,
            "motoristaEmail": driver.email,
            "status": "concluida"
        ]
        
        requestViewModel.finishRide(requestId: requestId, driverEmail: driver.email, rideData: rideData) { [weak self] success in
            
            guard let self = self else { return }
            
            if success {
                DispatchQueue.main.async {
                    // Atualiza o botão para mostrar que foi concluída
                    self.contentView.confirmRequestButton.setTitle("Corrida Concluída", for: .normal)
                    self.contentView.confirmRequestButton.backgroundColor = .systemGreen
                    self.contentView.confirmRequestButton.setTitleColor(.white, for: .normal)
                    self.contentView.confirmRequestButton.isEnabled = false
                    
                    // Para o monitoramento de localização
                    self.stopLocationMonitoring()
                    
                    // Mostra alerta de sucesso
                    self.showRideCompletedAlert()
                }
                print("✅ Corrida finalizada e salva no histórico")
            } else {
                print("❌ Erro ao finalizar corrida")
            }
        }
    }
    
    /// Mostra alerta de corrida concluída
    private func showRideCompletedAlert() {
        let alert = UIAlertController(
            title: "Corrida Concluída! 🎉",
            message: "A corrida foi finalizada com sucesso e salva no seu histórico.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Volta para a tela anterior
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
}

// MARK: – CLLocationManagerDelegate
extension RouteViewController: CLLocationManagerDelegate {
    
    /// Atualiza a localização atual do motorista
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Atualiza a localização atual do motorista
        currentDriverLocation = location.coordinate
        
        // Atualiza a localização no Firebase se necessário
        updateDriverLocationInFirebase()
        
        print("📍 Localização do motorista atualizada: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    /// Trata erros de localização
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Erro ao obter localização: \(error.localizedDescription)")
    }
}

// MARK: – MKMapViewDelegate
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
