//
//  RequestTableViewCell.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 26/05/25.
//
import Foundation
import UIKit
import CoreLocation

class RequestTableViewCell: UITableViewCell {
    
    lazy var passengerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    
    static let identifier: String = "RequestTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        addSubview(passengerNameLabel)
        addSubview(distanceLabel)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            passengerNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            passengerNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            distanceLabel.topAnchor.constraint(equalTo: passengerNameLabel.bottomAnchor, constant: 4),
            distanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            distanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    public func configure(with model: UserRequestModel, driverLocation: CLLocationCoordinate2D?){
        
        passengerNameLabel.text = model.nome
        
        guard let passengerCoord = model.coordinate,
              let driverCoord = driverLocation
        else {
            distanceLabel.text = "-- km de distancia"
            return
        }
        
        let driverLoc = CLLocation(latitude: driverCoord.latitude, longitude: driverCoord.longitude)
        let passengerLoc = CLLocation(latitude: passengerCoord.latitude, longitude: passengerCoord.longitude)
        
        let distanceMeters = driverLoc.distance(from: passengerLoc)
        let distanceKm = distanceMeters / 1000
        
        distanceLabel.text = "\(distanceKm)Km de distância"
    }
    
}
