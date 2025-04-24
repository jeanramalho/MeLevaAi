//
//  Auth.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 23/04/25.
//
import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class Authentication {
    
    let auth = Auth.auth()
    let database = Database.database().reference()
    
    
    public func createUser(email: String, password: String, userName: String, driver: Bool, completion: @escaping (Bool) -> Void){
        auth.createUser(withEmail: email, password: password) { authResult, error in
          
            if let erro = error {
                print("Erro ao criar conta: \(erro.localizedDescription)")
                completion(false)
                return
            }
            
            guard let userId = authResult?.user.uid else {
                completion(false)
                return
            }
            
            let userData = ["nome": userName, "email": email, "motorista": driver]
            let usuarios = self.database.child("usuarios")
            
            usuarios.child(userId).setValue(userData) { error, _ in
                if let erro = error {
                    print("Erro ao criar usuário: \(erro.localizedDescription)")
                    completion(false)
                } else {
                    print("Usuário criado com sucesso!")
                    completion(true)
                }
            }
        }
    }
    
    public func loginUser(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void){
        
        auth.signIn(withEmail: email, password: password) { user, error in
            
            if let error = error as NSError? {
                
                switch AuthErrorCode(rawValue: error.code) {
                case .wrongPassword, .invalidEmail:
                    completion(.failure(.invalidCredentials))
                case .userNotFound:
                    completion(.failure(.userNotFound))
                }
            }
            
            
            
        }
    }
    
    
}
