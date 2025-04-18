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
    
    private func setup(){
        
        setupContentView()
        setHierarchy()
        setConstraints()
    }
    
    private func setupContentView(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //permite que outros toques, como toques em botões continuem funcionando
        tapGesture.cancelsTouchesInView = false
        //adiciona o gesto a tela
        contentView.addGestureRecognizer(tapGesture)
        
    }
    
    private func setHierarchy(){
        view.addSubview(contentView)
    }
    
    private func setConstraints(){
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.setConstraintsToParent(self.view)

    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
}
