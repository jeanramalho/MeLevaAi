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
        
        self.keyboardAwareScrollView = scrollView
    }
    
    private struct AssociatedKeys {
        static var scrollViewKey = "keyboardAwareScrollView"
    }
    
    private var keyboardAwareScrollView: UIScrollView? {
        
        get {
                   return objc_getAssociatedObject(self, &AssociatedKeys.scrollViewKey) as? UIScrollView
               }
        set {
                   objc_setAssociatedObject(self, &AssociatedKeys.scrollViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
        guard let scrollView = keyboardAwareScrollView,
              let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom

        // ⬇️ Diminua esse valor pra evitar excesso de espaço
        let bottomInset = keyboardHeight - 50

        UIView.animate(withDuration: duration) {
            scrollView.contentInset.bottom = bottomInset
            scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        }
        
        if let activeField = view.findFirstResponder() {
            let convertedFrame = scrollView.convert(activeField.frame, from: activeField.superview)
            let visibleArea = scrollView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0))

            if !visibleArea.contains(convertedFrame.origin) {
                scrollView.scrollRectToVisible(convertedFrame, animated: true)
            }
        }
    }
    
    private func keyboardWillHide(notification: Notification, scrollView: UIScrollView){
        guard let scrollView = keyboardAwareScrollView,
                    let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

              UIView.animate(withDuration: duration) {
                  scrollView.contentInset.bottom = 0
                  scrollView.verticalScrollIndicatorInsets.bottom = 0
              }
    }
    
    // Para evitar memory leak
    func removeKeyboardObservers() {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
}
