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
    
    public func findFirstResponder() -> UIView? {
        
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}
