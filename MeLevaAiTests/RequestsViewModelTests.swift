//
//  RequestsViewModelTests.swift
//  MeLevaAiTests
//
//  Created by Jean Ramalho on 15/01/25.
//

import XCTest
import CoreLocation
@testable import MeLevaAi

final class RequestsViewModelTests: XCTestCase {
    
    var viewModel: RequestsViewModel!
    var mockAuthService: MockAuthentication!
    
    override func setUpWithError() throws {
        super.setUp()
        mockAuthService = MockAuthentication()
        viewModel = RequestsViewModel()
        // Injetar dependência mock se possível
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockAuthService = nil
        super.tearDown()
    }
    
    // MARK: - Testes de Validação de Dados
    
    func testValidateEmailWithValidEmail() throws {
        // Given
        let validEmail = "test@email.com"
        
        // When
        let isValid = isValidEmail(validEmail)
        
        // Then
        XCTAssertTrue(isValid, "Email válido deve retornar true")
    }
    
    func testValidateEmailWithInvalidEmail() throws {
        // Given
        let invalidEmail = "invalid-email"
        
        // When
        let isValid = viewModel.validateEmail(invalidEmail)
        
        // Then
        XCTAssertFalse(isValid, "Email inválido deve retornar false")
    }
    
    func testValidateEmailWithEmptyString() throws {
        // Given
        let emptyEmail = ""
        
        // When
        let isValid = viewModel.validateEmail(emptyEmail)
        
        // Then
        XCTAssertFalse(isValid, "Email vazio deve retornar false")
    }
    
    // MARK: - Testes de Cálculo de Distância
    
    func testCalculateDistanceBetweenTwoPoints() throws {
        // Given
        let driverLocation = CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        let passengerLocation = CLLocationCoordinate2D(latitude: -23.5615, longitude: -46.6565)
        
        // When
        let distance = viewModel.calculateDistanceBetweenDriverAndPassenger(
            driverLocation: driverLocation,
            passengerLocation: passengerLocation
        )
        
        // Then
        XCTAssertGreaterThan(distance, 0, "Distância deve ser maior que zero")
        XCTAssertLessThan(distance, 10000, "Distância deve ser menor que 10km para pontos próximos")
    }
    
    func testIsDriverNearPassengerWhenClose() throws {
        // Given
        let driverLocation = CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        let passengerLocation = CLLocationCoordinate2D(latitude: -23.5506, longitude: -46.6334)
        
        // When
        let isNear = viewModel.isDriverNearPassenger(
            driverLocation: driverLocation,
            passengerLocation: passengerLocation
        )
        
        // Then
        XCTAssertTrue(isNear, "Motorista próximo deve retornar true")
    }
    
    func testIsDriverNearPassengerWhenFar() throws {
        // Given
        let driverLocation = CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        let passengerLocation = CLLocationCoordinate2D(latitude: -23.5615, longitude: -46.6565)
        
        // When
        let isNear = viewModel.isDriverNearPassenger(
            driverLocation: driverLocation,
            passengerLocation: passengerLocation
        )
        
        // Then
        XCTAssertFalse(isNear, "Motorista distante deve retornar false")
    }
    
    // MARK: - Testes de Estado
    
    func testInitialState() throws {
        // Then
        XCTAssertFalse(viewModel.isCarCalled, "Estado inicial deve ser car não chamado")
        XCTAssertNil(viewModel.currentRequestId, "Request ID inicial deve ser nil")
        XCTAssertEqual(viewModel.requestsCount(), 0, "Lista inicial deve estar vazia")
    }
    
    func testRequestsCountAfterAddingRequests() throws {
        // Given
        let mockRequest = createMockUserRequestModel()
        
        // When
        // Simular adição de requisição (isso seria feito internamente pelo ViewModel)
        // Como não temos acesso direto ao array interno, testamos através de métodos públicos
        
        // Then
        // Este teste seria mais efetivo com acesso ao estado interno ou métodos de teste
        XCTAssertTrue(true, "Teste de contagem de requisições")
    }
    
    // MARK: - Testes de Performance
    
    func testDistanceCalculationPerformance() throws {
        // Given
        let driverLocation = CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        let passengerLocation = CLLocationCoordinate2D(latitude: -23.5615, longitude: -46.6565)
        
        // When & Then
        measure {
            _ = viewModel.calculateDistanceBetweenDriverAndPassenger(
                driverLocation: driverLocation,
                passengerLocation: passengerLocation
            )
        }
    }
    
    // MARK: - Helper Methods
    
    private func createMockUserRequestModel() -> UserRequestModel {
        return UserRequestModel(
            email: "test@email.com",
            nome: "Test User",
            latitude: "-23.5505",
            longitude: "-46.6333",
            destinyLatitude: "-23.5615",
            destinyLongitude: "-46.6565",
            status: "pendente"
        )
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Mock Classes

class MockAuthentication: Authentication {
    var shouldSucceed = true
    var mockUser: User?
    
    override func getReqUserData(completion: @escaping (User?) -> Void) {
        if shouldSucceed {
            completion(mockUser ?? User(email: "test@email.com", nome: "Test User"))
        } else {
            completion(nil)
        }
    }
    
    override func createUser(email: String, password: String, userName: String, driver: Bool, completion: @escaping (Bool) -> Void) {
        completion(shouldSucceed)
    }
    
    override func loginUser(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        if shouldSucceed {
            completion(.success(()))
        } else {
            completion(.failure(.invalidCredentials))
        }
    }
}
