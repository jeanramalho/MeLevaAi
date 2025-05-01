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
    
    public var userLocation = CLLocationCoordinate2D()
    
    
    public func requestACar(){
        auth.getReqUserData { user in
            
            guard let userLatitude = self.userLocation.latitude as? String else {return}
            guard let userLongitude = self.userLocation.longitude as? String else {return}
            
            let reqUserData: UserRequestModel = UserRequestModel(email: user.email,
                                                                 nome: user.nome,
                                                                 latitude: userLatitude,
                                                                 longitude: userLongitude)
        }
    }
}

extension RequestsViewModel: CLLocationManagerDelegate {
    
}
