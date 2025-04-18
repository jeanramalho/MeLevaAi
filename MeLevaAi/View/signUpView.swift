//
//  signUpView.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 18/04/25.
//
import Foundation
import UIKit

class signUpView: UIView {
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = Colors.darkSecondary
        label.textAlignment = .left
        label.text = "Nome:"
        return label
    }()
    
    lazy var nameTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Digite seu nome..."
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.darkSecondary.cgColor
        textField.layer.cornerRadius = 6
        return textField
    }()
    
    lazy var lastNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = Colors.darkSecondary
        label.textAlignment = .left
        label.text = "Sobrenome:"
        return label
    }()
    
    lazy var lastNameTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Digite seu sobrenome..."
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.darkSecondary.cgColor
        textField.layer.cornerRadius = 6
        return textField
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
    
    lazy var confirmPasswordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = Colors.darkSecondary
        label.textAlignment = .left
        label.text = "Confirmar senha:"
        return label
    }()
    
    lazy var confirmPasswordTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Confirme sua senha..."
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.darkSecondary.cgColor
        textField.layer.cornerRadius = 6
        return textField
    }()
    
    lazy var driveSwitchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    lazy var driveSwitch: UISwitch = {
        let driveSwitch = UISwitch()
        driveSwitch.translatesAutoresizingMaskIntoConstraints = false
        return driveSwitch
    }()
    
    lazy var driveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = Colors.darkPrimary
        label.textAlignment = .center
        label.text = "Motorista"
        return label
    }()
    
    lazy var passLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = Colors.darkPrimary
        label.textAlignment = .center
        label.text = "Passageiro"
        return label
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cadastrar", for: .normal)
        button.setTitleColor(Colors.defaultYellow, for: .normal)
        button.backgroundColor = Colors.darkPrimary
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
        
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(nameStackView)
        mainStackView.addArrangedSubview(lastNameStackView)
        mainStackView.addArrangedSubview(emailStackView)
        mainStackView.addArrangedSubview(passwordStackView)
        mainStackView.addArrangedSubview(confirmPasswordStackView)
        mainStackView.addArrangedSubview(driveSwitchStackView)
        mainStackView.addArrangedSubview(signUpButton)
        
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)
        
        lastNameStackView.addArrangedSubview(lastNameLabel)
        lastNameStackView.addArrangedSubview(lastNameTextField)
        
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        confirmPasswordStackView.addArrangedSubview(confirmPasswordLabel)
        confirmPasswordStackView.addArrangedSubview(confirmPasswordTextField)
        
        driveSwitchStackView.addArrangedSubview(driveLabel)
        driveSwitchStackView.addArrangedSubview(driveSwitch)
        driveSwitchStackView.addArrangedSubview(passLabel)
        
        
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 60),
            
            lastNameTextField.heightAnchor.constraint(equalToConstant: 60),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),
            
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 60),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
