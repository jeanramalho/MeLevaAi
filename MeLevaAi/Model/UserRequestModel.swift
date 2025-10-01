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
    var destinyLatitude: String
    var destinyLongitude: String
    var status: String // Status da corrida: "pendente", "aceita", "em_andamento"
    
    // converte as strings das coordenadas para CLLocationCoordinate2D
    var coordinate: CLLocationCoordinate2D? {
        guard
            let lat = Double(latitude),
            let long = Double(longitude)
            
            
        else {return nil}
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
                
    }
    
    // converte as strings das coordenadas do destino para CLLocationCoordinate2D
    var destinyCoordinate: CLLocationCoordinate2D? {
        guard
            let destLat = Double(destinyLatitude),
            let destLon = Double(destinyLongitude)
            
        else {return nil}
        return CLLocationCoordinate2D(latitude: destLat, longitude: destLon)
                
    }
}
