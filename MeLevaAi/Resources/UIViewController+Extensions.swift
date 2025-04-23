//
//  UIViewController+Extensions.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 18/04/25.
//
import Foundation
import UIKit

extension UIViewController {
    
    public func setupKeyboardObserver(){
        // Observa quando o teclado aparecer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Observa quando o teclado sumir
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
   
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
    
    @objc private func keyboardWillShow(notification: Notification){
        // pega a altura do teclado
        guard let userInfo = notification.userInfo,
                 let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
           
           let keyboardHeight = keyboardFrame.height
           
           if let scrollView = self.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
               let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
               scrollView.contentInset = insets
               scrollView.scrollIndicatorInsets = insets
           }
        
    }
 
    @objc private func keyboardWillHide(){
        
        // volta para posição original caso nao esteja
        if let scrollView = self.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
              scrollView.contentInset = .zero
              scrollView.scrollIndicatorInsets = .zero
          }
    }
    
    // Para evitar memory leak
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
       }
}
