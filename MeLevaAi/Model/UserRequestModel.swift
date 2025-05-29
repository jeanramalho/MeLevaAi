//
//  UserRequestModel.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 01/05/25.
//
import Foundation
import CoreLocation

struct UserRequestModel {
    var email: String
    var nome: String
    var latitude: String
    var longitude: String
    
    // converte as strings das coordenadas para CLLocationCoordinate2D
    var coordinate: CLLocationCoordinate2D? {
        guard
            let lat = Double(latitude),
            let long = Double(longitude)
        else {return nil}
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
                
    }
}
