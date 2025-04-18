//
//  SplashScreen.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 11/04/25.
//
import Foundation
import UIKit

class SplashScreenView: UIView {
    
    private lazy var logoImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "logo")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        backgroundColor = Colors.darkPrimary
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        addSubview(logoImageView)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
        ])
    }
}
