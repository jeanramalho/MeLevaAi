//
//  CustomAlert.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 23/04/25.
//
import Foundation
import UIKit

class CustomAlert {
    
    var title: String
    var message: String
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    func alert() -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        return alert
    }
    
}
