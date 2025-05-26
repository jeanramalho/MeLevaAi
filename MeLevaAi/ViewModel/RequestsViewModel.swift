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
import FirebaseDatabase


class RequestsViewModel: NSObject {
    
    private let requestService = Requests()
    private let auth = Authentication()
    private var currentRequestId: String?
    private var requestsList: [DataSnapshot] = []
    
    public var userLocation = CLLocationCoordinate2D()
    public var isCarCalled: Bool = false
    
    
    public func requestACar(completion: @escaping(Bool) -> Void){
        
        print("Tentando chamar um carro")

        auth.getReqUserData { user in
            
            guard let user = user else {
                completion(false)
                return
            }
            
            let userLatitude = String(self.userLocation.latitude)
            let userLongitude = String(self.userLocation.longitude)
            
            print("latitude: \(userLatitude) e longitude: \(userLongitude)")
            
            let reqUserData: UserRequestModel = UserRequestModel(email: user.email,
                                                                 nome: user.nome,
                                                                 latitude: userLatitude,
                                                                 longitude: userLongitude)
            
            self.requestService.createRequest(user: reqUserData) { success, requestId in
                if success, let requestId = requestId {
                    print("Requisição criada com sucesso")
                    self.isCarCalled = true
                    self.currentRequestId = requestId
                    completion(self.isCarCalled)
                } else {
                    print("Erro ao criar requisição")
                    self.isCarCalled = false
                    completion(self.isCarCalled)
                }
            }
        }
    }
    
    public func cancellCarRequest(completion: @escaping (Bool) -> Void){
        
        guard let requestId = currentRequestId else {
            print("Não há nenhuma request ativa para cancelar!")
            completion(false)
            return
        }
        
        requestService.deleteRequest(with: requestId) { success in
            if success {
                self.isCarCalled = false
                self.currentRequestId = nil
            }
            completion(success)
        }
    }
    
    public func getRequests(completion: @escaping ([DataSnapshot]) -> Void){
        
        let database = Database.database().reference()
        let requests = database.child("requisicoes")
        
        requests.observe(.childAdded) { snapShot in
            
            self.requestsList.append(snapShot)
            completion(self.requestsList)
        }
        
    }
}

extension RequestsViewModel: CLLocationManagerDelegate {
    
}
