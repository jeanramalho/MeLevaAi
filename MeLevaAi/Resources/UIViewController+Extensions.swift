//
//  UIViewController+Extensions.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 18/04/25.
//
import Foundation
import UIKit

extension UIViewController {
    
    public func setupKeyboardObserver(contentView: UIView? = nil){
        // Observa quando o teclado aparecer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Observa quando o teclado sumir
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let contentView = contentView {
            self.contentViewForKeyboard = contentView
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
    
    private struct AssociatedKeys {
            static var contentViewKey = "contentViewForKeyboard"
        }
        
    private var contentViewForKeyboard: UIView? {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.contentViewKey) as? UIView
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.contentViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    
    private func findScrollView(in view: UIView) -> UIScrollView? {
         
         if let scrollView = view as? UIScrollView {
             return scrollView
         }
         
         
         for subview in view.subviews {
             if let scrollView = findScrollView(in: subview) {
                 return scrollView
             }
         }
         
         return nil
     }
    
    private func getAllInputFields(in view: UIView) -> [UIView] {
        var fields: [UIView] = []
        
        
        if view is UITextField || view is UITextView {
            fields.append(view)
        }
   
        for subview in view.subviews {
            fields.append(contentsOf: getAllInputFields(in: subview))
        }
        
        return fields
    }
     
     
     private func findFirstResponder(in view: UIView) -> UIView? {
         if view.isFirstResponder {
             return view
         }
         
         for subview in view.subviews {
             if let firstResponder = findFirstResponder(in: subview) {
                 return firstResponder
             }
         }
         
         return nil
     }
    
    private func findLastElement(in view: UIView) -> UIView? {
        
        let buttons = view.subviews.compactMap { $0 as? UIButton }
        if let lastButton = buttons.last {
            return lastButton
        }
        
        
        for subview in view.subviews.reversed() {
            if let lastElement = findLastElement(in: subview) {
                return lastElement
            }
        }
        
      
        if view is UIButton || view is UISwitch {
            return view
        }
        
        return nil
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        // Pega a altura do teclado
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        
        if let contentView = contentViewForKeyboard ?? view,
           let scrollView = findScrollView(in: contentView) {
            
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
            
            
            if let activeField = findFirstResponder(in: contentView) {
                
                let allFields = getAllInputFields(in: contentView)
                
                if let index = allFields.firstIndex(of: activeField),
                   index >= allFields.count - 2 {
    
                    if let lastElement = findLastElement(in: contentView) {
                        // Calcula a posição do ultimo elemento
                        let lastElementFrame = lastElement.convert(lastElement.bounds, to: scrollView)
                        
                        let visibleHeight = scrollView.bounds.height - keyboardHeight

                        let spacing: CGFloat = 20
                        let offsetY = lastElementFrame.maxY - visibleHeight + spacing

                        let safeOffsetY = max(0, min(offsetY, scrollView.contentSize.height - visibleHeight))
                        
                        scrollView.setContentOffset(CGPoint(x: 0, y: safeOffsetY), animated: true)
                        return
                    }
                }

                let fieldFrame = activeField.convert(activeField.bounds, to: scrollView)
                let visibleArea = scrollView.bounds.inset(by: insets)
                
                if !visibleArea.contains(CGPoint(x: fieldFrame.midX, y: fieldFrame.maxY)) {
                    let spacing: CGFloat = 20
                    let scrollPoint = CGPoint(x: 0, y: fieldFrame.origin.y - spacing)
                    scrollView.setContentOffset(scrollPoint, animated: true)
                }
            }
        }
    }
 
    @objc private func keyboardWillHide() {
           // Reseta o scrollview
           if let contentView = contentViewForKeyboard ?? view,
              let scrollView = findScrollView(in: contentView) {
               scrollView.contentInset = .zero
               scrollView.scrollIndicatorInsets = .zero
           }
       }
    
    // Para evitar memory leak
      func removeKeyboardObservers() {
          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
      }
}
