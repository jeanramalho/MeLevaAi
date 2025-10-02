//
//  DriverTests.swift
//  MeLevaAiTests
//
//  Created by Jean Ramalho on 15/01/25.
//

import XCTest
import CoreLocation
@testable import MeLevaAi

final class DriverTests: XCTestCase {
    
    // MARK: - Testes de Inicialização
    
    func testDriverInitializationWithCoordinate() throws {
        // Given
        let email = "driver@email.com"
        let nome = "Driver Name"
        let coordinate = CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        
        // When
        let driver = Driver(email: email, nome: nome, coordinate: coordinate)
        
        // Then
        XCTAssertEqual(driver.email, email)
        XCTAssertEqual(driver.nome, nome)
        XCTAssertEqual(driver.latitude, "-23.5505")
        XCTAssertEqual(driver.longitude, "-46.6333")
        XCTAssertNotNil(driver.coordinate)
        XCTAssertEqual(driver.coordinate?.latitude, -23.5505, accuracy: 0.0001)
        XCTAssertEqual(driver.coordinate?.longitude, -46.6333, accuracy: 0.0001)
    }
    
    func testDriverInitializationWithDictionary() throws {
        // Given
        let dictionary: [String: Any] = [
            "email": "driver@email.com",
            "nome": "Driver Name",
            "latitude": "-23.5505",
            "longitude": "-46.6333"
        ]
        
        // When
        let driver = Driver(dictionary: dictionary)
        
        // Then
        XCTAssertNotNil(driver)
        XCTAssertEqual(driver?.email, "driver@email.com")
        XCTAssertEqual(driver?.nome, "Driver Name")
        XCTAssertEqual(driver?.latitude, "-23.5505")
        XCTAssertEqual(driver?.longitude, "-46.6333")
    }
    
    func testDriverInitializationWithInvalidDictionary() throws {
        // Given
        let invalidDictionary: [String: Any] = [
            "email": "driver@email.com"
            // Missing required fields
        ]
        
        // When
        let driver = Driver(dictionary: invalidDictionary)
        
        // Then
        XCTAssertNil(driver, "Driver com dicionário inválido deve retornar nil")
    }
    
    // MARK: - Testes de Conversão de Coordenadas
    
    func testCoordinatePropertyWithValidValues() throws {
        // Given
        let driver = Driver(
            email: "driver@email.com",
            nome: "Driver Name",
            coordinate: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        )
        
        // When
        let coordinate = driver.coordinate
        
        // Then
        XCTAssertNotNil(coordinate)
        XCTAssertEqual(coordinate?.latitude, -23.5505, accuracy: 0.0001)
        XCTAssertEqual(coordinate?.longitude, -46.6333, accuracy: 0.0001)
    }
    
    func testCoordinatePropertyWithInvalidValues() throws {
        // Given
        let driver = Driver(
            email: "driver@email.com",
            nome: "Driver Name",
            coordinate: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        )
        
        // Simular valores inválidos alterando as propriedades diretamente
        // Como latitude e longitude são let, vamos testar com dicionário inválido
        let invalidDictionary: [String: Any] = [
            "email": "driver@email.com",
            "nome": "Driver Name",
            "latitude": "invalid",
            "longitude": "invalid"
        ]
        
        // When
        let invalidDriver = Driver(dictionary: invalidDictionary)
        
        // Then
        XCTAssertNil(invalidDriver?.coordinate, "Coordenada inválida deve retornar nil")
    }
    
    // MARK: - Testes de Dictionary Conversion
    
    func testDictionaryProperty() throws {
        // Given
        let driver = Driver(
            email: "driver@email.com",
            nome: "Driver Name",
            coordinate: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        )
        
        // When
        let dictionary = driver.dictionary
        
        // Then
        XCTAssertEqual(dictionary["email"] as? String, "driver@email.com")
        XCTAssertEqual(dictionary["nome"] as? String, "Driver Name")
        XCTAssertEqual(dictionary["latitude"] as? String, "-23.5505")
        XCTAssertEqual(dictionary["longitude"] as? String, "-46.6333")
    }
    
    func testDictionaryPropertyWithZeroCoordinates() throws {
        // Given
        let driver = Driver(
            email: "driver@email.com",
            nome: "Driver Name",
            coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)
        )
        
        // When
        let dictionary = driver.dictionary
        
        // Then
        XCTAssertEqual(dictionary["latitude"] as? String, "0.0")
        XCTAssertEqual(dictionary["longitude"] as? String, "0.0")
    }
    
    // MARK: - Testes de Edge Cases
    
    func testDriverWithEmptyStrings() throws {
        // Given
        let driver = Driver(
            email: "",
            nome: "",
            coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)
        )
        
        // When & Then
        XCTAssertEqual(driver.email, "")
        XCTAssertEqual(driver.nome, "")
        XCTAssertEqual(driver.latitude, "0.0")
        XCTAssertEqual(driver.longitude, "0.0")
        XCTAssertNotNil(driver.coordinate)
    }
    
    func testDriverWithSpecialCharacters() throws {
        // Given
        let email = "driver+test@email.com"
        let nome = "João da Silva-Santos"
        let coordinate = CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        
        // When
        let driver = Driver(email: email, nome: nome, coordinate: coordinate)
        
        // Then
        XCTAssertEqual(driver.email, email)
        XCTAssertEqual(driver.nome, nome)
        XCTAssertNotNil(driver.coordinate)
    }
    
    // MARK: - Testes de Performance
    
    func testDriverCreationPerformance() throws {
        // When & Then
        measure {
            _ = Driver(
                email: "driver@email.com",
                nome: "Driver Name",
                coordinate: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
            )
        }
    }
    
    func testDictionaryConversionPerformance() throws {
        // Given
        let driver = Driver(
            email: "driver@email.com",
            nome: "Driver Name",
            coordinate: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        )
        
        // When & Then
        measure {
            _ = driver.dictionary
        }
    }
    
    func testCoordinateConversionPerformance() throws {
        // Given
        let driver = Driver(
            email: "driver@email.com",
            nome: "Driver Name",
            coordinate: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        )
        
        // When & Then
        measure {
            _ = driver.coordinate
        }
    }
}
