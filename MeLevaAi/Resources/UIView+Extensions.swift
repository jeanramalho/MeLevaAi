//
//  UIView+Extensions.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 17/04/25.
//
import Foundation
import UIKit

extension UIView {
    
    public func setConstraintsToParent(_ parent: UIView) {
           NSLayoutConstraint.activate([
               self.topAnchor.constraint(equalTo: parent.topAnchor),
               self.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
               self.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
               self.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
           ])
       }
    
    public func addTopBorder(to view: UIView, color: UIColor, height: CGFloat){
        
        // Remove camada anterior se houve
        view.layer.sublayers?
            .filter { $0.name == "topBorder"}
            .forEach { $0.removeFromSuperlayer()}
        
        let border = CALayer()
        border.name = "topBorder"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        
        view.layer.addSublayer(border)
    }

}
