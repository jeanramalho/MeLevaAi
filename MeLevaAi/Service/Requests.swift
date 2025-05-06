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
    
    public func createRequest(user: UserRequestModel, completion: @escaping (Bool, String?) -> Void){
        
        let requests = self.database.child("requisicoes")
        let requestId = requests.childByAutoId().key ?? UUID().uuidString
        
        let data: [String: Any] = [
            "email": user.email,
            "nome": user.nome,
            "latitude": user.latitude,
            "longitude": user.longitude
        ]
        
        requests.child(requestId).setValue(data) { error, _ in
            
            if let error = error {
                print("Erro ao criar requisição: \(error.localizedDescription)")
                completion(false, nil)
            } else {
                print("Requisição criada com sucesso!")
                completion(true, requestId)
            }
            
        }
    }
    
    public func deleteRequest(){
        
    }
}
