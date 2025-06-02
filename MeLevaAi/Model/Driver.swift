//
//  Driver.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 02/06/25.
//
import Foundation
import CoreLocation

struct Driver {
    let email: String
    let nome: String
    let latitude: String
    let longitude: String
    
    // Monta coordenadas do motorista
    var coordinate: CLLocationCoordinate2D? {
        
        guard let lat = Double(latitude),
                let lon = Double(longitude)
        else {return nil}
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    // realiza o de/para para o firebase
    var dictionary: [String: Any] {
        return [
            "email": email,
            "nome": nome,
            "latitude": latitude,
            "longitude": longitude,
        ]
    }
    
    // Inicializa a partir de um dicionario vindo do firebase
    init?(dictionary: [String: Any]) {
        guard
            let email = dictionary["email"] as? String,
            let nome = dictionary["nome"] as? String,
            let latitude = dictionary["latitude"] as? String,
            let longitude = dictionary["longitude"] as? String
        else {return nil}
        
        self.email = email
        self.nome = nome
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // Construtor manual
    init(email: String, nome: String, coordinate: CLLocationCoordinate2D) {
        self.email = email
        self.nome = nome
        self.latitude = "\(coordinate.latitude)"
        self.longitude = "\(coordinate.longitude)"
    }
}
