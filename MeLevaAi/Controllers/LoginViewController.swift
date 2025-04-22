//
//  LoginViewController.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 17/04/25.
//
import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    private let contentView: LoginView = LoginView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    private func setup(){
        
        hideNavigationBar()
        hideKeyboard(self, contentView: self.contentView)
        setupContentView()
        setHierarchy()
        setConstraints()
    }
    
    private func setupContentView(){
        
        
        contentView.signUpButton.addTarget(self, action: #selector(showSignUpView), for: .touchUpInside)
        
    }
    
    private func setHierarchy(){
        view.addSubview(contentView)
    }
    
    private func setConstraints(){
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.setConstraintsToParent(self.view)

    }
    

    
    @objc private func showSignUpView(){
        
        let signUpViewController = SingUpViewController()
        
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
}
