//
//  SplashSceenViewController.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 11/04/25.
//
import Foundation
import UIKit

class SplashSceenViewController: UIViewController {
    
    private let contentView: SplashScreenView = SplashScreenView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        view.addSubview(contentView)
    }
    
    private func setConstraints(){
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.setConstraintsToParent(self.view)
       
    }
}
