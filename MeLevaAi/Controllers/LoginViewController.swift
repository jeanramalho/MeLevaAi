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
    private let authService = Authentication()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    private func setup(){

        isUserLogged()
        hideNavigationBar()
        hideKeyboard(self, contentView: self.contentView)
        setupContentView()
        setHierarchy()
        setConstraints()
    }
    
    private func isUserLogged(){
        
        authService.checkAuth { isUserLogged, userId in
            
            guard let userUid = userId else {return}
            
            let driverViewController = DriverViewController()
            let pessengerViewController = PessengerViewController()
            
            if isUserLogged == true {
                
                self.authService.getUserDriverStatus(userId: userUid) { isDriver in
                    if isDriver == true {
                        self.navigationController?.setViewControllers([driverViewController], animated: true)
                    } else {
                        self.navigationController?.setViewControllers([pessengerViewController], animated: true)
                    }
                }
                
            } else {
                print("Usuário não logado")
            }
        }
    }
    
    private func setupContentView(){
        
        contentView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        contentView.signUpButton.addTarget(self, action: #selector(showSignUpView), for: .touchUpInside)
        contentView.showPasswordSwitch.addTarget(self, action: #selector(showPassword), for: .valueChanged)
        
    }
    
    private func setHierarchy(){
        view.addSubview(contentView)
    }
    
    private func setConstraints(){
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.setConstraintsToParent(self.view)

    }
    
    @objc private func showPassword(){
        
        let showPasswordSwitch = contentView.showPasswordSwitch
        let passwordTextField = contentView.passwordTextField
        
        if showPasswordSwitch.isOn == true {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
        
    }

    
    @objc private func showSignUpView(){
        
        let signUpViewController = SingUpViewController()
        
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @objc private func login(){
        
        guard let email = contentView.emailTextField.text as String? else {return}
        guard let password = contentView.passwordTextField.text as String? else {return}
        
        if email.isEmpty || password.isEmpty {
            let alert = CustomAlert(title: "Preencha todos os campos!", message: "É necessário que você preencha todos os campos com dados válidos para fazer login")
            present(alert.alert(), animated: true, completion: nil)
            print("É necessário preencher todos os campos!")
        }
        
        authService.loginUser(email: email, password: password) { result in
            switch result {
            case .success(let success):
                print("Login realizado com sucesso!")
            case .failure(let error):
                print("Erro ao realizar Login: \(error.localizedDescription)")
            }
        }
    }
}
