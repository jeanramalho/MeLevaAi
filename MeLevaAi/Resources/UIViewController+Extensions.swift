//
//  UIViewController+Extensions.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 18/04/25.
//
import Foundation
import UIKit

extension UIViewController {
    
    public func setupNavigationBar(){
        
        self.navigationController?.navigationBar.isHidden = false
        
        if let navigationbar = navigationController?.navigationBar {
                   
                   let navigationBarLayout = UINavigationBarAppearance()
                   navigationBarLayout.configureWithOpaqueBackground()
                   navigationBarLayout.backgroundColor = Colors.darkPrimary
                   
                   let fontAttributes = [
                       NSAttributedString.Key.foregroundColor: Colors.defaultYellow,
                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .medium)
                   ]
                   
                   navigationBarLayout.titleTextAttributes = fontAttributes
                   
                   navigationbar.standardAppearance = navigationBarLayout
                   navigationbar.scrollEdgeAppearance = navigationBarLayout
                   navigationbar.compactAppearance = navigationBarLayout
                   
                   navigationbar.tintColor = Colors.defaultYellow
               }
    }
    
    public func hideKeyboard(_ target: UIViewController, contentView: UIView){
        let tapGesture = UITapGestureRecognizer(target: target, action: #selector(dismissKeyboard))
        //permite que outros toques, como toques em botões continuem funcionando
        tapGesture.cancelsTouchesInView = false
        //adiciona o gesto a tela
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
}
