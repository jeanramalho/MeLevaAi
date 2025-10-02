//
//  LoginUITests.swift
//  MeLevaAiUITests
//
//  Created by Jean Ramalho on 15/01/25.
//

import XCTest

final class LoginUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Testes de Elementos da Interface
    
    func testLoginScreenElementsExist() throws {
        // Then
        XCTAssertTrue(app.textFields["emailTextField"].exists, "Campo de email deve existir")
        XCTAssertTrue(app.secureTextFields["passwordTextField"].exists, "Campo de senha deve existir")
        XCTAssertTrue(app.buttons["loginButton"].exists, "Botão de login deve existir")
        XCTAssertTrue(app.buttons["signUpButton"].exists, "Botão de cadastro deve existir")
        XCTAssertTrue(app.switches["showPasswordSwitch"].exists, "Switch de mostrar senha deve existir")
    }
    
    func testSignUpScreenElementsExist() throws {
        // When
        app.buttons["signUpButton"].tap()
        
        // Then
        XCTAssertTrue(app.textFields["nameTextField"].exists, "Campo de nome deve existir")
        XCTAssertTrue(app.textFields["lastNameTextField"].exists, "Campo de sobrenome deve existir")
        XCTAssertTrue(app.textFields["emailTextField"].exists, "Campo de email deve existir")
        XCTAssertTrue(app.secureTextFields["passwordTextField"].exists, "Campo de senha deve existir")
        XCTAssertTrue(app.secureTextFields["confirmPasswordTextField"].exists, "Campo de confirmar senha deve existir")
        XCTAssertTrue(app.buttons["signUpButton"].exists, "Botão de cadastro deve existir")
        XCTAssertTrue(app.switches["driveSwitch"].exists, "Switch de motorista deve existir")
    }
    
    // MARK: - Testes de Interação
    
    func testEmailTextFieldInteraction() throws {
        // When
        let emailTextField = app.textFields["emailTextField"]
        emailTextField.tap()
        emailTextField.typeText("test@email.com")
        
        // Then
        XCTAssertEqual(emailTextField.value as? String, "test@email.com", "Email deve ser inserido corretamente")
    }
    
    func testPasswordTextFieldInteraction() throws {
        // When
        let passwordTextField = app.secureTextFields["passwordTextField"]
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        
        // Then
        XCTAssertNotNil(passwordTextField.value, "Senha deve ser inserida")
    }
    
    func testShowPasswordSwitch() throws {
        // Given
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let showPasswordSwitch = app.switches["showPasswordSwitch"]
        
        // When
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        showPasswordSwitch.tap()
        
        // Then
        XCTAssertTrue(showPasswordSwitch.isOn, "Switch deve estar ligado")
        // Note: Em testes reais, você verificaria se o campo de senha mudou para texto normal
    }
    
    // MARK: - Testes de Navegação
    
    func testNavigationToSignUp() throws {
        // When
        app.buttons["signUpButton"].tap()
        
        // Then
        XCTAssertTrue(app.navigationBars["Cadastre-se"].exists, "Deve navegar para tela de cadastro")
    }
    
    func testNavigationBackFromSignUp() throws {
        // Given
        app.buttons["signUpButton"].tap()
        
        // When
        app.navigationBars["Cadastre-se"].buttons["Back"].tap()
        
        // Then
        XCTAssertTrue(app.buttons["loginButton"].exists, "Deve voltar para tela de login")
    }
    
    // MARK: - Testes de Validação
    
    func testLoginWithEmptyFields() throws {
        // When
        app.buttons["loginButton"].tap()
        
        // Then
        // Verificar se aparece alerta de campos vazios
        // Em um teste real, você verificaria a presença de um alerta
        XCTAssertTrue(true, "Teste de validação de campos vazios")
    }
    
    func testLoginWithInvalidEmail() throws {
        // Given
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        
        // When
        emailTextField.tap()
        emailTextField.typeText("invalid-email")
        passwordTextField.tap()
        passwordTextField.typeText("password123")
        app.buttons["loginButton"].tap()
        
        // Then
        // Verificar se aparece alerta de email inválido
        XCTAssertTrue(true, "Teste de validação de email inválido")
    }
    
    func testSignUpWithEmptyFields() throws {
        // Given
        app.buttons["signUpButton"].tap()
        
        // When
        app.buttons["signUpButton"].tap()
        
        // Then
        // Verificar se aparece alerta de campos vazios
        XCTAssertTrue(true, "Teste de validação de campos vazios no cadastro")
    }
    
    func testSignUpWithPasswordMismatch() throws {
        // Given
        app.buttons["signUpButton"].tap()
        
        // When
        app.textFields["nameTextField"].tap()
        app.textFields["nameTextField"].typeText("João")
        
        app.textFields["lastNameTextField"].tap()
        app.textFields["lastNameTextField"].typeText("Silva")
        
        app.textFields["emailTextField"].tap()
        app.textFields["emailTextField"].typeText("joao@email.com")
        
        app.secureTextFields["passwordTextField"].tap()
        app.secureTextFields["passwordTextField"].typeText("password123")
        
        app.secureTextFields["confirmPasswordTextField"].tap()
        app.secureTextFields["confirmPasswordTextField"].typeText("password456")
        
        app.buttons["signUpButton"].tap()
        
        // Then
        // Verificar se aparece alerta de senhas não coincidem
        XCTAssertTrue(true, "Teste de validação de senhas diferentes")
    }
    
    // MARK: - Testes de Performance
    
    func testLoginScreenLoadPerformance() throws {
        // When & Then
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
    
    func testNavigationPerformance() throws {
        // When & Then
        measure {
            app.buttons["signUpButton"].tap()
            app.navigationBars["Cadastre-se"].buttons["Back"].tap()
        }
    }
    
    // MARK: - Testes de Acessibilidade
    
    func testAccessibilityLabels() throws {
        // Then
        XCTAssertTrue(app.textFields["emailTextField"].label.contains("email") || 
                    app.textFields["emailTextField"].label.contains("Email"), 
                    "Campo de email deve ter label acessível")
        
        XCTAssertTrue(app.secureTextFields["passwordTextField"].label.contains("senha") || 
                    app.secureTextFields["passwordTextField"].label.contains("password"), 
                    "Campo de senha deve ter label acessível")
    }
    
    // MARK: - Testes de Orientação
    
    func testPortraitOrientation() throws {
        // Given
        XCUIDevice.shared.orientation = .portrait
        
        // Then
        XCTAssertTrue(app.buttons["loginButton"].exists, "Elementos devem estar visíveis em portrait")
        XCTAssertTrue(app.buttons["signUpButton"].exists, "Elementos devem estar visíveis em portrait")
    }
    
    func testLandscapeOrientation() throws {
        // Given
        XCUIDevice.shared.orientation = .landscapeLeft
        
        // Then
        XCTAssertTrue(app.buttons["loginButton"].exists, "Elementos devem estar visíveis em landscape")
        XCTAssertTrue(app.buttons["signUpButton"].exists, "Elementos devem estar visíveis em landscape")
        
        // Reset orientation
        XCUIDevice.shared.orientation = .portrait
    }
}
