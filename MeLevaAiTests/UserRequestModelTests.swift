//
//  UserRequestModelTests.swift
//  MeLevaAiTests
//
//  Created by Jean Ramalho on 15/01/25.
//

import XCTest
import CoreLocation
@testable import MeLevaAi

final class UserRequestModelTests: XCTestCase {
    
    // MARK: - Testes de Inicialização
    
    func testUserRequestModelInitialization() throws {
        // Given
        let email = "test@email.com"
        let nome = "Test User"
        let latitude = "-23.5505"
        let longitude = "-46.6333"
        let destinyLatitude = "-23.5615"
        let destinyLongitude = "-46.6565"
        let status = "pendente"
        
        // When
        let userRequest = UserRequestModel(
            email: email,
            nome: nome,
            latitude: latitude,
            longitude: longitude,
            destinyLatitude: destinyLatitude,
            destinyLongitude: destinyLongitude,
            status: status
        )
        
        // Then
        XCTAssertEqual(userRequest.email, email)
        XCTAssertEqual(userRequest.nome, nome)
        XCTAssertEqual(userRequest.latitude, latitude)
        XCTAssertEqual(userRequest.longitude, longitude)
        XCTAssertEqual(userRequest.destinyLatitude, destinyLatitude)
        XCTAssertEqual(userRequest.destinyLongitude, destinyLongitude)
        XCTAssertEqual(userRequest.status, status)
    }
    
    // MARK: - Testes de Conversão de Coordenadas
    
    func testCoordinateConversionWithValidValues() throws {
        // Given
        let latitude = "-23.5505"
        let longitude = "-46.6333"
        let userRequest = UserRequestModel(
            email: "test@email.com",
            nome: "Test User",
            latitude: latitude,
            longitude: longitude,
            destinyLatitude: "-23.5615",
            destinyLongitude: "-46.6565",
            status: "pendente"
        )
        
        // When
        let coordinate = userRequest.coordinate
        
        // Then
        XCTAssertNotNil(coordinate, "Coordenada deve ser válida")
        XCTAssertEqual(coordinate?.latitude, -23.5505, accuracy: 0.0001)
        XCTAssertEqual(coordinate?.longitude, -46.6333, accuracy: 0.0001)
    }
    
    func testCoordinateConversionWithInvalidValues() throws {
        // Given
        let userRequest = UserRequestModel(
            email: "test@email.com",
            nome: "Test User",
            latitude: "invalid",
            longitude: "invalid",
            destinyLatitude: "-23.5615",
            destinyLongitude: "-46.6565",
            status: "pendente"
        )
        
        // When
        let coordinate = userRequest.coordinate
        
        // Then
        XCTAssertNil(coordinate, "Coordenada inválida deve retornar nil")
    }
    
    func testDestinyCoordinateConversionWithValidValues() throws {
        // Given
        let destinyLatitude = "-23.5615"
        let destinyLongitude = "-46.6565"
        let userRequest = UserRequestModel(
            email: "test@email.com",
            nome: "Test User",
            latitude: "-23.5505",
            longitude: "-46.6333",
            destinyLatitude: destinyLatitude,
            destinyLongitude: destinyLongitude,
            status: "pendente"
        )
        
        // When
        let destinyCoordinate = userRequest.destinyCoordinate
        
        // Then
        XCTAssertNotNil(destinyCoordinate, "Coordenada de destino deve ser válida")
        XCTAssertEqual(destinyCoordinate?.latitude, -23.5615, accuracy: 0.0001)
        XCTAssertEqual(destinyCoordinate?.longitude, -46.6565, accuracy: 0.0001)
    }
    
    func testDestinyCoordinateConversionWithInvalidValues() throws {
        // Given
        let userRequest = UserRequestModel(
            email: "test@email.com",
            nome: "Test User",
            latitude: "-23.5505",
            longitude: "-46.6333",
            destinyLatitude: "invalid",
            destinyLongitude: "invalid",
            status: "pendente"
        )
        
        // When
        let destinyCoordinate = userRequest.destinyCoordinate
        
        // Then
        XCTAssertNil(destinyCoordinate, "Coordenada de destino inválida deve retornar nil")
    }
    
    // MARK: - Testes de Estados
    
    func testStatusValidation() throws {
        // Given
        let validStatuses = ["pendente", "aceita", "em_andamento", "concluida"]
        
        for status in validStatuses {
            // When
            let userRequest = UserRequestModel(
                email: "test@email.com",
                nome: "Test User",
                latitude: "-23.5505",
                longitude: "-46.6333",
                destinyLatitude: "-23.5615",
                destinyLongitude: "-46.6565",
                status: status
            )
            
            // Then
            XCTAssertEqual(userRequest.status, status, "Status deve ser mantido corretamente")
        }
    }
    
    // MARK: - Testes de Edge Cases
    
    func testEmptyStringValues() throws {
        // Given
        let userRequest = UserRequestModel(
            email: "",
            nome: "",
            latitude: "",
            longitude: "",
            destinyLatitude: "",
            destinyLongitude: "",
            status: ""
        )
        
        // When & Then
        XCTAssertEqual(userRequest.email, "")
        XCTAssertEqual(userRequest.nome, "")
        XCTAssertEqual(userRequest.latitude, "")
        XCTAssertEqual(userRequest.longitude, "")
        XCTAssertEqual(userRequest.destinyLatitude, "")
        XCTAssertEqual(userRequest.destinyLongitude, "")
        XCTAssertEqual(userRequest.status, "")
        XCTAssertNil(userRequest.coordinate)
        XCTAssertNil(userRequest.destinyCoordinate)
    }
    
    func testZeroCoordinates() throws {
        // Given
        let userRequest = UserRequestModel(
            email: "test@email.com",
            nome: "Test User",
            latitude: "0",
            longitude: "0",
            destinyLatitude: "0",
            destinyLongitude: "0",
            status: "pendente"
        )
        
        // When
        let coordinate = userRequest.coordinate
        let destinyCoordinate = userRequest.destinyCoordinate
        
        // Then
        XCTAssertNotNil(coordinate)
        XCTAssertEqual(coordinate?.latitude, 0.0, accuracy: 0.0001)
        XCTAssertEqual(coordinate?.longitude, 0.0, accuracy: 0.0001)
        
        XCTAssertNotNil(destinyCoordinate)
        XCTAssertEqual(destinyCoordinate?.latitude, 0.0, accuracy: 0.0001)
        XCTAssertEqual(destinyCoordinate?.longitude, 0.0, accuracy: 0.0001)
    }
    
    // MARK: - Testes de Performance
    
    func testCoordinateConversionPerformance() throws {
        // Given
        let userRequest = UserRequestModel(
            email: "test@email.com",
            nome: "Test User",
            latitude: "-23.5505",
            longitude: "-46.6333",
            destinyLatitude: "-23.5615",
            destinyLongitude: "-46.6565",
            status: "pendente"
        )
        
        // When & Then
        measure {
            _ = userRequest.coordinate
            _ = userRequest.destinyCoordinate
        }
    }
}
