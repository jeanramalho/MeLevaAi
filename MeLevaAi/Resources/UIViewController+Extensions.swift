//
//  UIViewController+Extensions.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 18/04/25.
//
import Foundation
import UIKit

extension UIViewController {
    
    public func setupKeyboardObserver(for scrollView: UIScrollView){
        // Observa quando o teclado aparecer
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {[weak self] notification in
            self?.keyboardWillShow(notification: notification, scrollView: scrollView)
        }
        
        // Observa quando o teclado sumir
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] notification in
            self?.keyboardWillHide(notification: notification, scrollView: scrollView)
        }
    }
    
    public func hideNavigationBar(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
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
    
    private func keyboardWillShow(notification: Notification, scrollView: UIScrollView){
        
        // Pega a altura do teclado
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        
        let bottomInset = keyboardFrame.height
        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        
    }
    
    private func keyboardWillHide(notification: Notification, scrollView: UIScrollView){
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}
