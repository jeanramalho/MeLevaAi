//
//  LoginView.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 17/04/25.
//
import Foundation
import UIKit

class LoginView: UIView {
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "logo")
        return image
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = Colors.darkSecondary
        label.textAlignment = .left
        label.text = "Email:"
        return label
    }()
    
    lazy var emailTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Digite seu email..."
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.darkSecondary.cgColor
        textField.layer.cornerRadius = 6
        return textField
    }()
    
    lazy var passwordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = Colors.darkSecondary
        label.textAlignment = .left
        label.text = "Senha:"
        return label
    }()
    
    lazy var passwordTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Digite sua senha..."
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.darkSecondary.cgColor
        textField.layer.cornerRadius = 6
        return textField
    }()
    
    lazy var showPasswordSwitch: UISwitch = {
        let showPassSwitch = UISwitch()
        showPassSwitch.translatesAutoresizingMaskIntoConstraints = false
        return showPassSwitch
    }()
    
    lazy var showPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vizualizar senha!"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var showPasswordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Entrar", for: .normal)
        button.setTitleColor(Colors.defaultYellow, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = Colors.darkPrimary
        button.layer.cornerRadius = 12
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cadastrar", for: .normal)
        button.setTitleColor(Colors.darkPrimary, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = Colors.defaultYellow
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.darkSecondary.cgColor
        button.layer.cornerRadius = 12
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        backgroundColor = .white
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        
        addSubview(logoImageView)
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(emailStackView)
        mainStackView.addArrangedSubview(passwordStackView)
        mainStackView.addArrangedSubview(showPasswordStackView)
        mainStackView.addArrangedSubview(loginButton)
        mainStackView.addArrangedSubview(signUpButton)
        
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        showPasswordStackView.addArrangedSubview(showPasswordSwitch)
        showPasswordStackView.addArrangedSubview(showPasswordLabel)
        
        
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([

            
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            logoImageView.bottomAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -18),
            
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
          
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
