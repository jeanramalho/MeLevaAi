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
        DispatchQueue.main.async {
            // pega o model do passageiro e o requestId
            let passengerModel = self.viewModel.getARequest(at: indexPath.row)
            let requestId = self.viewModel.getRequestId(at: indexPath.row)
            
            self.authService.getReqUserData { [weak self] user in
                guard
                    let self = self,
                    let user = user,
                    let driverCoord = self.driverLocation
                else {
                    return
                }
                
                let driverModel = Driver(email: user.email,
                                         nome: user.nome,
                                         coordinate: driverCoord)
                
                DispatchQueue.main.async {
                    let route = RouteViewController(driver: driverModel,
                                                    pessenger: passengerModel,
                                                    requestId: requestId)
                    
                    self.navigationController?.pushViewController(route, animated: true)
                }
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
