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
}
