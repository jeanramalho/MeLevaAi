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
    private var currentRequestId: String?
    private var requestsList: [(model: UserRequestModel, id: String)] = []
    
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
    
    public func checkIfHaveRequests() {
        
        let database = auth.database
        
        self.auth.getReqUserData { user in
            
            guard let user = user else {return}
            
            let userEmail: String = user.email
            let requests = database.child("requisicoes")
            let getRequest = requests.queryOrdered(byChild: "email").queryEqual(toValue: userEmail)
            
            getRequest.observeSingleEvent(of: .childAdded) { snapshot in
                
                if snapshot.value != nil {
                    self.isCarCalled = true
                    
                } else {
                    self.isCarCalled = false
                    
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
    
    public func getRequests(completion: @escaping () -> Void){
        
        let database = auth.database
        let requestsRef = database.child("requisicoes")
        
        requestsRef.removeAllObservers()
        
        requestsRef.observe(.childAdded) { snapShot in
            
            print("–– snapshot.key:\n", snapShot.key)
            print("–– snapshot.value:\n", snapShot.value ?? "Nulo")
            
            // tenta converter em dicionário
            guard let value = snapShot.value as? [String: Any] else {
                print("❌ snapshot.value não é [String:Any] em \(snapShot.key) → \(snapShot.value ?? "nulo")")
                return
            }
            
            let requestId = snapShot.key
            
            guard
                  let nome = value["nome"] as? String,
                  let email = value["email"] as? String,
                  let latitude = value["latitude"] as? String,
                  let longitude = value["longitude"] as? String
            else {
                print("❌ Campos obrigatórios faltando ou em formato errado em \(snapShot.key): \(value)")
                return
            }
            
            let model = UserRequestModel(email: email,
                                           nome: nome,
                                           latitude: latitude,
                                           longitude: longitude)
            
            self.requestsList.append((model: model, id: requestId))
            completion()
        }
    }
    
    public func getARequest(at index: Int) -> UserRequestModel {
        return requestsList[index].model
    }
    
    public func getRequestId(at index: Int) -> String {
        return requestsList[index].id
    }
    
    public func requestsCount() -> Int {
        return requestsList.count
    }
    
    // Atualizar requisição confirmada
    public func updateConfirmedRequest(passengerEmail: String, completion: @escaping (Bool) -> Void){
        
        let database = auth.database
        let requests = database.child("requisicoes")
        
        requests.queryOrdered(byChild: "email").queryEqual(toValue: passengerEmail).observeSingleEvent(of: .childAdded) { snapshot in
            
            let driverLatitude = String(self.userLocation.latitude)
            let driverLongitude = String(self.userLocation.longitude)
            
            let driverData: [String: Any] = [
                "motoristaLatitude": driverLatitude,
                "motoristaLongitude": driverLongitude
           ]
            
            snapshot.ref.updateChildValues(driverData) { error, _ in
            
                if let error = error {
                    print("❌ Erro ao aceitar corrida: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } withCancel: { error in
            print("Erro na query da requisição: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    
}

extension RequestsViewModel: CLLocationManagerDelegate {
    
}
