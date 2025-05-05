//
//  RequestsViewModel.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 01/05/25.
//
import Foundation
import UIKit
import MapKit
import CoreLocation


class RequestsViewModel: NSObject {
    
    private let requestService = Requests()
    private let auth = Authentication()
    private var isCarCalled: Bool = false
    
    public var userLocation = CLLocationCoordinate2D()
    
    
    public func requestACar(completion: @escaping(Bool) -> Void){
        
        print("Tentando chamar um carro")

        auth.getReqUserData { user in
            
            let userLatitude = String(self.userLocation.latitude)
            let userLongitude = String(self.userLocation.longitude)
            
            print("latitude: \(userLatitude) e longitude: \(userLongitude)")
            
            guard let userEmail = user?.email as String? else {return}
            guard let userName = user?.nome as String? else {return}
            
            let reqUserData: UserRequestModel = UserRequestModel(email: userEmail,
                                                                 nome: userName,
                                                                 latitude: userLatitude,
                                                                 longitude: userLongitude)
            
            self.requestService.createRequest(user: reqUserData) { success in
                if success {
                    print("Requisição criada com sucesso")
                    self.isCarCalled = true
                    completion(self.isCarCalled)
                } else {
                    print("Erro ao criar requisição")
                    self.isCarCalled = false
                    completion(self.isCarCalled)
                }
            }
        }
    }
}

extension RequestsViewModel: CLLocationManagerDelegate {
    
}
