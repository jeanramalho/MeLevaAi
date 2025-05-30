//
//  RouteView.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 30/05/25.
//
import Foundation
import UIKit
import MapKit

class RouteView: UIView {
    
    lazy var routeMapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var confirmRequestButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirmar Carona", for: .normal)
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
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        addSubview(routeMapView)
        addSubview(confirmRequestButton)
    }
    
    private func setConstraints(){
        
        routeMapView.setConstraintsToParent(self)
        
        NSLayoutConstraint.activate([
            
        ])
    }
}
