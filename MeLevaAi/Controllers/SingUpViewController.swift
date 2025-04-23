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
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    private func setup(){
        
        self.title = "Cadastre-se"
        
        setupKeyboardObserver(for: mainScrollView)
        hideKeyboard(self, contentView: self.contentView)
        setupNavigationBar()
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        view.addSubview(mainScrollView)
        
        mainScrollView.addSubview(contentView)
    }
    
    private func setConstraints(){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.setConstraintsToParent(self.view)
        contentView.setConstraintsToParent(self.mainScrollView)
        
        NSLayoutConstraint.activate([
            mainScrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            contentView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
        ])
    }
    
    deinit {
        removeKeyboardObservers()
    }
}
