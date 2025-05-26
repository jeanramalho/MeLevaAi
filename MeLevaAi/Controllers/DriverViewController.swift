//
//  DriverViewController.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 27/04/25.
//
import Foundation
import UIKit

class DriverViewController: UIViewController {
    
    private let contenView: DriverView = DriverView()
    private let authService = Authentication()
    private let viewModel = RequestsViewModel()
    
    private var requests: [UserRequestModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        
        self.title = "MeLevaAí - Motorista"
        
        setupNavigationBar()
        setupContentView()
        setHierarchy()
        setConstraints()
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
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.identifier, for: indexPath) as? RequestTableViewCell else {return UITableViewCell()}
        
        
        return cell
    }
    
    
}
