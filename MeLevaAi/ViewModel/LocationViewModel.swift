//
//  LocationViewModel.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 29/04/25.
//
import Foundation
import UIKit
import MapKit

class LocationViewModel  {
    
    private var locationManager = CLLocationManager()
    
    public func setupViewModel(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationViewModel: MKMapViewDelegate, CLLocationManagerDelegate {
    
}
