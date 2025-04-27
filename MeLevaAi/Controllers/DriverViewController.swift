//
//  DriverViewController.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 27/04/25.
//
import Foundation
import UIKit

class DriverViewController: UIViewController {
    
    private let contenView: DriverView = DriverView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        view.addSubview(contenView)
    }
    
    private func setConstraints(){
      
        contenView.translatesAutoresizingMaskIntoConstraints = false
        contenView.setConstraintsToParent(self.view)
    }
}
