//
//  AuthenticationTests.swift
//  MeLevaAiTests
//
//  Created by Jean Ramalho on 15/01/25.
//

import XCTest
@testable import MeLevaAi

final class AuthenticationTests: XCTestCase {
    
    var authService: Authentication!
    
    override func setUpWithError() throws {
        super.setUp()
        authService = Authentication()
    }
    
    override func tearDownWithError() throws {
        authService = nil
        super.tearDown()
    }
    
    // MARK: - Testes de Validação de Email
    
    func testEmailValidationWithValidEmails() throws {
        // Given
        let validEmails = [
            "test@email.com",
            "user.name@domain.co.uk",
            "user+tag@example.org",
            "123@test.com"
        ]
        
        for email in validEmails {
            // When
            let isValid = isValidEmail(email)
            
            // Then
            XCTAssertTrue(isValid, "Email '\(email)' deve ser válido")
        }
    }
    
    func testEmailValidationWithInvalidEmails() throws {
        // Given
        let invalidEmails = [
            "",
            "invalid-email",
            "@email.com",
            "test@",
            "test..test@email.com",
            "test@.com",
            "test@email.",
            "test@email..com"
        ]
        
        for email in invalidEmails {
            // When
            let isValid = isValidEmail(email)
            
            // Then
            XCTAssertFalse(isValid, "Email '\(email)' deve ser inválido")
        }
    }
    
    // MARK: - Testes de Validação de Senha
    
    func testPasswordValidationWithValidPasswords() throws {
        // Given
        let validPasswords = [
            "123456",
            "password123",
            "abcdef",
            "1234567890"
        ]
        
        for password in validPasswords {
            // When
            let isValid = isValidPassword(password)
            
            // Then
            XCTAssertTrue(isValid, "Senha '\(password)' deve ser válida")
        }
    }
    
    func testPasswordValidationWithInvalidPasswords() throws {
        // Given
        let invalidPasswords = [
            "",
            "12345",
            "abc",
            "123"
        ]
        
        for password in invalidPasswords {
            // When
            let isValid = isValidPassword(password)
            
            // Then
            XCTAssertFalse(isValid, "Senha '\(password)' deve ser inválida")
        }
    }
    
    // MARK: - Testes de Validação de Nome
    
    func testNameValidationWithValidNames() throws {
        // Given
        let validNames = [
            "João Silva",
            "Maria Santos",
            "José da Silva",
            "Ana-Maria",
            "Pedro José Santos"
        ]
        
        for name in validNames {
            // When
            let isValid = isValidName(name)
            
            // Then
            XCTAssertTrue(isValid, "Nome '\(name)' deve ser válido")
        }
    }
    
    func testNameValidationWithInvalidNames() throws {
        // Given
        let invalidNames = [
            "",
            " ",
            "A",
            "123",
            "João123",
            "Maria@Silva"
        ]
        
        for name in invalidNames {
            // When
            let isValid = isValidName(name)
            
            // Then
            XCTAssertFalse(isValid, "Nome '\(name)' deve ser inválido")
        }
    }
    
    // MARK: - Testes de Sanitização de Dados
    
    func testDataSanitization() throws {
        // Given
        let input = "  Test User  "
        let expected = "Test User"
        
        // When
        let sanitized = sanitizeInput(input)
        
        // Then
        XCTAssertEqual(sanitized, expected, "Dados devem ser sanitizados corretamente")
    }
    
    func testDataSanitizationWithSpecialCharacters() throws {
        // Given
        let input = "<script>alert('test')</script>"
        let expected = "&lt;script&gt;alert('test')&lt;/script&gt;"
        
        // When
        let sanitized = sanitizeInput(input)
        
        // Then
        XCTAssertEqual(sanitized, expected, "Caracteres especiais devem ser escapados")
    }
    
    // MARK: - Testes de Performance
    
    func testEmailValidationPerformance() throws {
        let email = "test@email.com"
        
        measure {
            for _ in 0..<1000 {
                _ = isValidEmail(email)
            }
        }
    }
    
    func testPasswordValidationPerformance() throws {
        let password = "password123"
        
        measure {
            for _ in 0..<1000 {
                _ = isValidPassword(password)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    private func isValidName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.count >= 2 && trimmedName.allSatisfy { $0.isLetter || $0.isWhitespace || $0 == "-" }
    }
    
    private func sanitizeInput(_ input: String) -> String {
        return input.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
}
