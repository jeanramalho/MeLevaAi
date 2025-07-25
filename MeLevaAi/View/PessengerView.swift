//
//  PessengerView.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 27/04/25.
//
import Foundation
import UIKit
import MapKit

class PessengerView: UIView {
    
    lazy var destinyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var destinyMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var currentLocationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var destinyLocationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var currentLocationTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Meu Local"
        textField.isEnabled = false
        textField.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.darkSecondary.cgColor
        textField.layer.cornerRadius = 6
        return textField
    }()
    
    lazy var currentLocationCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var destinyLocationCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var destinyLocationTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Digite seu destino..."
        textField.isEnabled = false
        textField.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.darkSecondary.cgColor
        textField.layer.cornerRadius = 6
        return textField
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    lazy var callCarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pedir Carona", for: .normal)
        button.backgroundColor = Colors.darkSecondary
        button.setTitleColor(Colors.defaultYellow, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
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
        
        addSubview(mapView)
        addSubview(destinyView)
        addSubview(callCarButton)
        
        destinyView.addSubview(destinyMainStackView)
        
        destinyMainStackView.addArrangedSubview(currentLocationStackView)
        destinyMainStackView.addArrangedSubview(destinyLocationStackView)
        
        currentLocationStackView.addArrangedSubview(currentLocationCircleView)
        currentLocationStackView.addArrangedSubview(currentLocationTextField)
        
        destinyLocationStackView.addArrangedSubview(destinyLocationCircleView)
        destinyLocationStackView.addArrangedSubview(destinyLocationCircleView)
    }
    
    private func setConstraints(){
        
        mapView.setConstraintsToParent(self)
        
        self.addTopBorder(to: destinyLocationStackView, color: .gray, height: 1)
        
        NSLayoutConstraint.activate([
            
            destinyView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            destinyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            destinyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            destinyView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            
            destinyMainStackView.topAnchor.constraint(equalTo: destinyView.topAnchor, constant: 8),
            destinyMainStackView.leadingAnchor.constraint(equalTo: destinyView.leadingAnchor, constant: 8),
            destinyMainStackView.trailingAnchor.constraint(equalTo: destinyView.trailingAnchor, constant: -8),
            destinyMainStackView.bottomAnchor.constraint(equalTo: destinyView.bottomAnchor, constant: -8),
            
            currentLocationStackView.topAnchor.constraint(equalTo: destinyMainStackView.topAnchor),
            currentLocationStackView.leadingAnchor.constraint(equalTo: destinyMainStackView.leadingAnchor),
            currentLocationStackView.trailingAnchor.constraint(equalTo: destinyMainStackView.trailingAnchor),
            
            destinyMainStackView.topAnchor.constraint(equalTo: currentLocationStackView.bottomAnchor, constant: 8),
            destinyMainStackView.leadingAnchor.constraint(equalTo: destinyMainStackView.leadingAnchor),
            destinyMainStackView.trailingAnchor.constraint(equalTo: destinyMainStackView.trailingAnchor),
            destinyMainStackView.bottomAnchor.constraint(equalTo: destinyMainStackView.bottomAnchor),
            
            destinyLocationTextField.heightAnchor.constraint(equalToConstant: 30),
            
            currentLocationTextField.heightAnchor.constraint(equalToConstant: 30),
            
            currentLocationCircleView.heightAnchor.constraint(equalToConstant: 16),
            
            destinyLocationCircleView.heightAnchor.constraint(equalToConstant: 16),
            
            callCarButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            callCarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            callCarButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            callCarButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
