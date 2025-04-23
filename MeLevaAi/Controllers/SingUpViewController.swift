//
//  SingUpViewController.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 18/04/25.
//
import Foundation
import UIKit

class SingUpViewController: UIViewController {
    

    private let contentView: signUpView = signUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    private func setup(){
        
        self.title = "Cadastre-se"
        
        setupKeyboardObserver()
        hideKeyboard(self, contentView: self.contentView)
        setupNavigationBar()
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
    
    deinit {
        removeKeyboardObservers()
    }
}
