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
        
        showLoginView()
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
    
    private func showLoginView(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            let loginViewController = LoginViewController()
            self.navigationController?.setViewControllers([loginViewController], animated: true)
        }
    }
}
