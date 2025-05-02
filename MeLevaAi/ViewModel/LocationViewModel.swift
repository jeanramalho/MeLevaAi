//
//  LocationViewModel.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 29/04/25.
//
import Foundation
import UIKit
import CoreLocation
import MapKit

class LocationViewModel: NSObject  {
    
    var currentLocation: CLLocationCoordinate2D?
    
    private var locationManager = CLLocationManager()
    private var userLocation = CLLocationCoordinate2D()
    private var requestViewModel = RequestsViewModel()
    
    // Closure que vai ser chamada quando a localização for atualizada
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func setupViewModel(){

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
   
}

extension LocationViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let coordinates = locations.last?.coordinate {
            self.requestViewModel.userLocation = coordinates
            self.currentLocation = coordinates
            self.onLocationUpdate?(coordinates)
        }
        
        
    }
}
