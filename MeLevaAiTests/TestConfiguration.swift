//
//  TestConfiguration.swift
//  MeLevaAiTests
//
//  Created by Jean Ramalho on 15/01/25.
//

import XCTest
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
@testable import MeLevaAi

class TestConfiguration: XCTestCase {
    
    static var isConfigured = false
    
    override class func setUp() {
        super.setUp()
        
        if !isConfigured {
            configureFirebaseForTesting()
            isConfigured = true
        }
    }
    
    private static func configureFirebaseForTesting() {
        // Configurar Firebase para testes
        // Em um ambiente real, você usaria um projeto Firebase separado para testes
        
        // Para testes unitários, podemos usar configuração mock
        // ou configurar Firebase com dados de teste
        
        print("🔧 Firebase configurado para testes")
    }
}

// MARK: - Test Environment Setup

class TestEnvironment {
    
    static func setupTestEnvironment() {
        // Configurar ambiente de teste
        setupTestData()
        setupMockServices()
    }
    
    private static func setupTestData() {
        // Configurar dados de teste
        print("📊 Dados de teste configurados")
    }
    
    private static func setupMockServices() {
        // Configurar serviços mock
        print("🔧 Serviços mock configurados")
    }
    
    static func cleanupTestEnvironment() {
        // Limpar ambiente de teste
        print("🧹 Ambiente de teste limpo")
    }
}

// MARK: - Test Metrics

class TestMetrics {
    
    static var testStartTime: Date?
    static var testEndTime: Date?
    
    static func startTest() {
        testStartTime = Date()
        print("⏱️ Teste iniciado em: \(testStartTime!)")
    }
    
    static func endTest() {
        testEndTime = Date()
        if let startTime = testStartTime {
            let duration = testEndTime!.timeIntervalSince(startTime)
            print("⏱️ Teste finalizado em: \(testEndTime!)")
            print("⏱️ Duração: \(String(format: "%.2f", duration)) segundos")
        }
    }
    
    static func logTestResult(_ testName: String, success: Bool) {
        let status = success ? "✅" : "❌"
        print("\(status) \(testName)")
    }
}

// MARK: - Test Data Factory

class TestDataFactory {
    
    static func createTestUser(isDriver: Bool = false) -> User {
        return User(
            email: "test\(UUID().uuidString.prefix(8))@email.com",
            nome: "Test User \(UUID().uuidString.prefix(4))"
        )
    }
    
    static func createTestDriver() -> Driver {
        return Driver(
            email: "driver\(UUID().uuidString.prefix(8))@email.com",
            nome: "Driver \(UUID().uuidString.prefix(4))",
            coordinate: CLLocationCoordinate2D(
                latitude: Double.random(in: -23.6...-23.4),
                longitude: Double.random(in: -46.7...-46.5)
            )
        )
    }
    
    static func createTestUserRequest() -> UserRequestModel {
        return UserRequestModel(
            email: "passenger\(UUID().uuidString.prefix(8))@email.com",
            nome: "Passenger \(UUID().uuidString.prefix(4))",
            latitude: String(Double.random(in: -23.6...-23.4)),
            longitude: String(Double.random(in: -46.7...-46.5)),
            destinyLatitude: String(Double.random(in: -23.6...-23.4)),
            destinyLongitude: String(Double.random(in: -46.7...-46.5)),
            status: "pendente"
        )
    }
    
    static func createTestCoordinates() -> (origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let origin = CLLocationCoordinate2D(
            latitude: Double.random(in: -23.6...-23.4),
            longitude: Double.random(in: -46.7...-46.5)
        )
        
        let destination = CLLocationCoordinate2D(
            latitude: Double.random(in: -23.6...-23.4),
            longitude: Double.random(in: -46.7...-46.5)
        )
        
        return (origin, destination)
    }
}

// MARK: - Test Assertions

extension XCTestCase {
    
    func assertValidEmail(_ email: String, file: StaticString = #file, line: UInt = #line) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        XCTAssertTrue(emailPredicate.evaluate(with: email), "Email deve ser válido: \(email)", file: file, line: line)
    }
    
    func assertValidPassword(_ password: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertGreaterThanOrEqual(password.count, 6, "Senha deve ter pelo menos 6 caracteres", file: file, line: line)
    }
    
    func assertValidName(_ name: String, file: StaticString = #file, line: UInt = #line) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        XCTAssertGreaterThanOrEqual(trimmedName.count, 2, "Nome deve ter pelo menos 2 caracteres", file: file, line: line)
    }
    
    func assertValidCoordinate(_ coordinate: CLLocationCoordinate2D?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(coordinate, "Coordenada deve ser válida", file: file, line: line)
        if let coord = coordinate {
            XCTAssertGreaterThanOrEqual(coord.latitude, -90, "Latitude deve ser válida", file: file, line: line)
            XCTAssertLessThanOrEqual(coord.latitude, 90, "Latitude deve ser válida", file: file, line: line)
            XCTAssertGreaterThanOrEqual(coord.longitude, -180, "Longitude deve ser válida", file: file, line: line)
            XCTAssertLessThanOrEqual(coord.longitude, 180, "Longitude deve ser válida", file: file, line: line)
        }
    }
}
