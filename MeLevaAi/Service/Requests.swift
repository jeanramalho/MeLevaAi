//
//  Request.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 30/04/25.
//
import Foundation
import FirebaseDatabase

class Requests {
    
    private let database = Database.database().reference()
    
    public func createRequest(user: UserRequestModel, completion: @escaping (Bool) -> Void){
        
        let requests = self.database.child("requisicoes")
        let data: [String: Any] = [
            "email": user.email,
            "nome": user.nome,
            "latitude": user.latitude,
            "longitude": user.longitude
        ]
        
        requests.childByAutoId().setValue(data) { error, _ in
            
            if let error = error {
                print("Erro ao criar requisição: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Requisição criada com sucesso!")
                completion(true)
            }
            
        }
    }
}
