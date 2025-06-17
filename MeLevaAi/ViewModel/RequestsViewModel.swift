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
    private(set) var currentRequestId: String?
    private var requestsList: [(model: UserRequestModel, id: String)] = []
    
    public var userLocation = CLLocationCoordinate2D()
    public var driverLocation = CLLocationCoordinate2D()
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
    
    public func checkIfHaveRequests(completion: @escaping (Bool) -> Void) {
        
        let database = auth.database
        
        self.auth.getReqUserData { user in
            
            guard let user = user else {
                completion(false)
                return
            }
            
            let email = user.email
            let requests = database.child("requisicoes")
            
            requests
                .queryOrdered(byChild: "email")
                .queryEqual(toValue: email)
                .observeSingleEvent(of: .childAdded) { snapshot in
                    
                    if let snapshotDict = snapshot.value as? [String: Any] {
                        
                        self.isCarCalled = true
                        self.currentRequestId = snapshot.key
                        completion(true)
                    } else {
                        self.isCarCalled = false
                        self.currentRequestId = nil
                        completion(false)
                    }
                } withCancel: { error in
                    print("Erro ao achar requisição: \(error.localizedDescription)")
                    self.isCarCalled = false
                    self.currentRequestId = nil
                    completion(false)
                }
   
        }
        
    }
    
    public func updatingRequest(completion: @escaping (Bool, Double?) -> Void){
        
        let database = auth.database
        
        self.auth.getReqUserData { user in
            
            guard let user = user else {return}
            
            let email = user.email
            let requests = database.child("requisicoes")
            let requestUser = requests.queryOrdered(byChild: "email").queryEqual(toValue: email)
            
            requestUser.observe(.childChanged) { snapshot in
                
                if let snapshoDict = snapshot.value as? [String: Any],
                   let driverLatitude = snapshoDict["motoristaLatitude"] as? Double,
                   let driverLongitude = snapshoDict["motoristaLongitude"] as? Double
                {
                    self.driverLocation = CLLocationCoordinate2D(latitude: driverLatitude, longitude: driverLongitude)
                    let distance = self.calcuteDistanceDriverToPassenger()
                    completion(true, distance)
                } else {
                    completion(false, nil)
                }
            }
            
        
                
        }
    }
    
    private func calcuteDistanceDriverToPassenger() -> Double {
        
        let driverLatitude = self.driverLocation.latitude
        let driverLongitude = self.driverLocation.longitude
        
        let passengerLatitude = self.userLocation.latitude
        let passengerLongitude = self.userLocation.longitude
        
        let currentDriverLocation = CLLocation(latitude: driverLatitude, longitude: driverLongitude)
        let currentPassengerLocation = CLLocation(latitude: passengerLatitude, longitude: passengerLongitude)
        
        // Calcular distancia entre motorista e passageiro
        let calcDistance = currentDriverLocation.distance(from: currentPassengerLocation)
        let distanceKM = round(calcDistance / 1000)
        
        return distanceKM
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
    public func updateConfirmedRequest(passengerEmail: String, driverCoordinate: CLLocationCoordinate2D, completion: @escaping (Bool) -> Void){
        
        let database = auth.database
        let requests = database.child("requisicoes")
        
        requests.queryOrdered(byChild: "email").queryEqual(toValue: passengerEmail).observeSingleEvent(of: .childAdded)
        { snapshot in
            
            let driverData: [String: Any] = [
                "motoristaLatitude": driverCoordinate.latitude,
                "motoristaLongitude": driverCoordinate.longitude
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
    
    public func createDriverAndPassengerAnnotation(completion: @escaping (_ driverAnnotation: MKPointAnnotation?, _ passengerAnnotation: MKPointAnnotation?) -> Void) {
        
        let driverLatitude = self.driverLocation.latitude
        let driverLongitude = self.driverLocation.longitude
        
        let passengerLatitude = self.userLocation.latitude
        let passengerLongitude = self.userLocation.longitude
        
        let currentDriverLocation = CLLocationCoordinate2D(latitude: driverLatitude, longitude: driverLongitude)
        let currentPassengerLocation = CLLocationCoordinate2D(latitude: passengerLatitude, longitude: passengerLongitude)
        
        // Criando annotation motorista
        let driverAnnotation = MKPointAnnotation()
        driverAnnotation.coordinate = currentDriverLocation
        driverAnnotation.title = "Motorista"
        
        // Criando annotation passageiro
        let passengerAnnotation = MKPointAnnotation()
        passengerAnnotation.coordinate = currentPassengerLocation
        passengerAnnotation.title = "Passageiro"
        
        completion(driverAnnotation, passengerAnnotation)
    }
    
    
}

extension RequestsViewModel: CLLocationManagerDelegate {
    
}
