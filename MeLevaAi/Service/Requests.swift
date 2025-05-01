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
    
    public func createRequest(){
        
        let requests = self.database.child("requisicoes")
        
    }
}
