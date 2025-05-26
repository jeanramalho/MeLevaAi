//
//  RequestTableViewCell.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 26/05/25.
//
import Foundation
import UIKit

class RequestTableViewCell: UITableViewCell {
    
    
    static let identifier: String = "RequestTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
    }
    
}
