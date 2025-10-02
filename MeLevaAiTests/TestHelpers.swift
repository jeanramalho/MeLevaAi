//
//  TestHelpers.swift
//  MeLevaAiTests
//
//  Created by Jean Ramalho on 15/01/25.
//

import XCTest
import CoreLocation
@testable import MeLevaAi

// MARK: - Test Helpers

class TestHelpers {
    
    static func createMockUser() -> User {
        return User(email: "test@email.com", nome: "Test User")
    }
    
    static func createMockDriver() -> Driver {
        return Driver(
            email: "driver@email.com",
            nome: "Driver Name",
            coordinate: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
        )
    }
    
    static func createMockUserRequest() -> UserRequestModel {
        return UserRequestModel(
            email: "passenger@email.com",
            nome: "Passenger Name",
            latitude: "-23.5505",
            longitude: "-46.6333",
            destinyLatitude: "-23.5615",
            destinyLongitude: "-46.6565",
            status: "pendente"
        )
    }
    
    static func createMockDriverDictionary() -> [String: Any] {
        return [
            "email": "driver@email.com",
            "nome": "Driver Name",
            "latitude": "-23.5505",
            "longitude": "-46.6333"
        ]
    }
    
    static func createMockUserRequestDictionary() -> [String: Any] {
        return [
            "email": "passenger@email.com",
            "nome": "Passenger Name",
            "latitude": "-23.5505",
            "longitude": "-46.6333",
            "destinyLatitude": "-23.5615",
            "destinyLongitude": "-46.6565",
            "status": "pendente"
        ]
    }
}

// MARK: - XCTest Extensions

extension XCTestCase {
    
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 5.0) {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        wait(for: [expectation], timeout: timeout)
    }
    
    func waitForElementToDisappear(_ element: XCUIElement, timeout: TimeInterval = 5.0) {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        wait(for: [expectation], timeout: timeout)
    }
    
    func tapAndWaitForKeyboard(_ textField: XCUIElement) {
        textField.tap()
        XCTAssertTrue(textField.waitForExistence(timeout: 2.0), "Keyboard should appear")
    }
    
    func dismissKeyboard() {
        XCUIApplication().keyboards.buttons["return"].tap()
    }
}

// MARK: - Mock Classes for Testing

class MockLocationManager: CLLocationManager {
    var mockLocation: CLLocation?
    var mockError: Error?
    var shouldReturnLocation = true
    
    override func startUpdatingLocation() {
        // Simular atualização de localização
        if shouldReturnLocation, let location = mockLocation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.delegate?.locationManager?(self, didUpdateLocations: [location])
            }
        } else if let error = mockError {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.delegate?.locationManager?(self, didFailWithError: error)
            }
        }
    }
    
    override func stopUpdatingLocation() {
        // Mock implementation
    }
}

class MockRequestsService: Requests {
    var shouldSucceed = true
    var mockRequestId: String?
    var mockError: Error?
    
    override func createRequest(user: UserRequestModel, completion: @escaping (Bool, String?) -> Void) {
        if shouldSucceed {
            completion(true, mockRequestId ?? "mock-request-id")
        } else {
            completion(false, nil)
        }
    }
    
    override func deleteRequest(with requestId: String, completion: @escaping (Bool) -> Void) {
        completion(shouldSucceed)
    }
}

// MARK: - Test Data Constants

struct TestConstants {
    static let validEmail = "test@email.com"
    static let invalidEmail = "invalid-email"
    static let validPassword = "password123"
    static let invalidPassword = "123"
    static let validName = "João Silva"
    static let invalidName = "A"
    
    static let saoPauloCoordinate = CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
    static let nearbyCoordinate = CLLocationCoordinate2D(latitude: -23.5506, longitude: -46.6334)
    static let farCoordinate = CLLocationCoordinate2D(latitude: -23.5615, longitude: -46.6565)
    
    static let mockUserData: [String: Any] = [
        "email": "test@email.com",
        "nome": "Test User",
        "motorista": false
    ]
    
    static let mockDriverData: [String: Any] = [
        "email": "driver@email.com",
        "nome": "Driver Name",
        "motorista": true
    ]
}

// MARK: - Assertion Helpers

func XCTAssertCoordinateEqual(_ coordinate1: CLLocationCoordinate2D?, 
                             _ coordinate2: CLLocationCoordinate2D?, 
                             accuracy: CLLocationDegrees = 0.0001,
                             _ message: String = "",
                             file: StaticString = #file,
                             line: UInt = #line) {
    guard let coord1 = coordinate1, let coord2 = coordinate2 else {
        XCTAssertEqual(coordinate1, coordinate2, message, file: file, line: line)
        return
    }
    
    XCTAssertEqual(coord1.latitude, coord2.latitude, accuracy: accuracy, message + " - Latitude", file: file, line: line)
    XCTAssertEqual(coord1.longitude, coord2.longitude, accuracy: accuracy, message + " - Longitude", file: file, line: line)
}

func XCTAssertDistanceEqual(_ distance1: Double,
                           _ distance2: Double,
                           accuracy: Double = 1.0,
                           _ message: String = "",
                           file: StaticString = #file,
                           line: UInt = #line) {
    XCTAssertEqual(distance1, distance2, accuracy: accuracy, message, file: file, line: line)
}
