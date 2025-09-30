//
//  DriverViewController.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 27/04/25.
//
import Foundation
import UIKit
import CoreLocation

class DriverViewController: UIViewController {
    
    private let contenView: DriverView = DriverView()
    private let authService = Authentication()
    private let viewModel = RequestsViewModel()
    private let locationManager = CLLocationManager()
    
    private var requests: [UserRequestModel] = []
    private var driverLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchRequests()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove observadores para evitar vazamentos de memória
        self.viewModel.removeAllObservers()
    }
    
    private func setup(){
        
        self.title = "MeLevaAí - Motorista"
        
        setupDriverLocationManager()
        fetchRequests()
        setupNavigationBar()
        setupContentView()
        setHierarchy()
        setConstraints()
    }
    
    private func setupDriverLocationManager(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupContentView(){
        let logOutButton = UIBarButtonItem(title: "< Sair",
                                           style: .plain,
                                           target: self,
                                           action: #selector(logOutAccount))
        
        self.navigationItem.leftBarButtonItem = logOutButton
        
        let requestsTableView = contenView.requestsTableView
        requestsTableView.dataSource = self
        requestsTableView.delegate = self
        requestsTableView.register(RequestTableViewCell.self, forCellReuseIdentifier: RequestTableViewCell.identifier)
    }
    
    private func fetchRequests(){
        self.viewModel.getRequests(completion: { [weak self]  in
            DispatchQueue.main.async {
                self?.contenView.requestsTableView.reloadData()
            }
        })
        
        // Configura o observador para requisições canceladas
        self.setupRequestCancellationObserver()
    }
    
    // Configura o observador para detectar quando uma requisição é cancelada
    private func setupRequestCancellationObserver() {
        self.viewModel.updateRequestCaseCancell { [weak self] in
            DispatchQueue.main.async {
                // Atualiza a tableView quando uma requisição é cancelada
                self?.contenView.requestsTableView.reloadData()
                print("🔄 TableView atualizada após cancelamento de requisição")
            }
        }
    }
    
    private func setHierarchy(){
        view.addSubview(contenView)
    }
    
    private func setConstraints(){
        
        contenView.translatesAutoresizingMaskIntoConstraints = false
        contenView.setConstraintsToParent(self.view)
    }
    
    @objc private func logOutAccount(){
        authService.logOut { auth in
            
            let loginViewController = LoginViewController()
            
            if auth == false {
                self.navigationController?.setViewControllers([loginViewController], animated: true)
            }
        }
    }
}

extension DriverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.requestsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.identifier, for: indexPath) as? RequestTableViewCell else {return UITableViewCell()}
        
        let request = self.viewModel.getARequest(at: indexPath.row)
        
        cell.configure(with: request, driverLocation: driverLocation)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        // Pega dados da request e retorna em um Model de UserRequestModel
        let passenger = self.viewModel.getARequest(at: indexPath.row)
        // Pega o requestId do nó da requisição no firebase
        let requestId = self.viewModel.getRequestId(at: indexPath.row)
        // Pega os dados do motorista e instancia o model Driver
        self.authService.getReqUserData { [weak self] user in
            guard
                let self = self,
                let user = user,
                let driverCoord = self.driverLocation
            else {
                return
            }
        
        // instancia o model Driver
        let driver = Driver(email: user.email, nome: user.nome, coordinate: driverCoord)
            
        // Envia dados para a viewcontroller de destino
            DispatchQueue.main.async {
                
                let routeViewController = RouteViewController(driver: driver, pessenger: passenger, requestId: requestId)
                
                self.navigationController?.pushViewController(routeViewController, animated: true)
            }
        }
        
    }
    
    
}

extension DriverViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {return}
        self.driverLocation = loc.coordinate
        
        contenView.requestsTableView.reloadData()
    }
}
