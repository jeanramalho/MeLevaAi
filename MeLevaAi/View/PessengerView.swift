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
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    lazy var callCarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Solicitar Carro", for: .normal)
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
        addSubview(callCarButton)
    }
    
    private func setConstraints(){
        
        mapView.setConstraintsToParent(self)
        
        NSLayoutConstraint.activate([
            callCarButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            callCarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            callCarButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            callCarButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
