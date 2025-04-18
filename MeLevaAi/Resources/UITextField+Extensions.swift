//
//  UITextField+Extensions.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 17/04/25.
//
import Foundation
import UIKit

class PaddedTextField: UITextField {
    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
