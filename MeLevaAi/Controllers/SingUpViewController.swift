//
//  SingUpViewController.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 18/04/25.
//
import Foundation
import UIKit

class SingUpViewController: UIViewController {
    

    private let contentView: signUpView = signUpView()
    private let authService = Authentication()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    private func setup(){
        
        self.title = "Cadastre-se"
        
        let signUpButton = contentView.signUpButton
        signUpButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        
        setupContentView()
        setupKeyboardObserver(contentView: contentView)
        hideKeyboard(self, contentView: self.contentView)
        setupNavigationBar()
        setHierarchy()
        setConstraints()
    }
    
    private func setupContentView(){
        
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
        let confirmPasswordTextField = contentView.confirmPasswordTextField
        
        if showPasswordSwitch.isOn == true {
            passwordTextField.isSecureTextEntry = false
            confirmPasswordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
            confirmPasswordTextField.isSecureTextEntry = true
        }
    }
    
    @objc private func createUser(){
 
        let name = contentView.nameTextField.text ?? ""
        let lastName = contentView.lastNameTextField.text ?? ""
        let email = contentView.emailTextField.text ?? ""
        let password = contentView.passwordTextField.text ?? ""
        let confirmPassword = contentView.confirmPasswordTextField.text ?? ""
        let driver = contentView.driveSwitch.isOn
        
        let fullName = "\(String(describing: name)) \(String(describing: lastName))"
        
        if name == "" || lastName == "" || email == "" || password == "" || confirmPassword == "" {
            
            if password.count < 6 || confirmPassword.count < 6 {
                let alert = CustomAlert(title: "Caracteres insuficientes!", message: "Sua senha deve ter 6 ou mais caracteres. Tente novamente!")
                
                self.present(alert.alert(), animated: true)
            }
            
            let alert = CustomAlert(title: "Preencha todos os campos", message: "Para continuar seu cadastro preencha todos os campos solicitados!")
            self.present(alert.alert(), animated: true, completion: nil)
        }
        
        if password == confirmPassword {
            
            authService.createUser(email: email, password: password, userName: fullName, driver: driver) { success in
                if success {
                    print("Usuário criado!")
                } else {
                    let alert = CustomAlert(title: "Erro ao criar usuário!", message: "Ocorreu um erro ao criar seu usuário. Por favor tente novamente!")
                    print("Erro ao criar usuário!")
                }
            }
            
        } else {
            
            let alert = CustomAlert(title: "Senhas não correspondem!", message: "Os campos senha e confirmar senha devem possuir a mesma senha. Revise os dados e tente novavemente!")
            self.present(alert.alert(), animated: true, completion: nil)
        }
        
    }
    
    deinit {
        removeKeyboardObservers()
    }
}
