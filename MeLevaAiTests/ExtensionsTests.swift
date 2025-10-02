//
//  ExtensionsTests.swift
//  MeLevaAiTests
//
//  Created by Jean Ramalho on 15/01/25.
//

import XCTest
import UIKit
@testable import MeLevaAi

final class ExtensionsTests: XCTestCase {
    
    // MARK: - UIView Extensions Tests
    
    func testSetConstraintsToParent() throws {
        // Given
        let parentView = UIView()
        let childView = UIView()
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        // When
        parentView.addSubview(childView)
        childView.setConstraintsToParent(parentView)
        
        // Then
        XCTAssertFalse(childView.translatesAutoresizingMaskIntoConstraints, "translatesAutoresizingMaskIntoConstraints deve ser false")
        XCTAssertEqual(childView.superview, parentView, "Child view deve ter parent view como superview")
    }
    
    func testAddTopBorder() throws {
        // Given
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let borderColor = UIColor.red
        let borderHeight: CGFloat = 2.0
        
        // When
        view.addTopBorder(to: view, color: borderColor, height: borderHeight)
        
        // Then
        let borderLayers = view.layer.sublayers?.filter { $0.name == "topBorder" }
        XCTAssertNotNil(borderLayers, "Deve ter camadas de borda")
        XCTAssertEqual(borderLayers?.count, 1, "Deve ter exatamente uma camada de borda")
        
        if let borderLayer = borderLayers?.first {
            XCTAssertEqual(borderLayer.backgroundColor, borderColor.cgColor, "Cor da borda deve ser correta")
            XCTAssertEqual(borderLayer.frame.height, borderHeight, "Altura da borda deve ser correta")
        }
    }
    
    // MARK: - UITextField Extensions Tests
    
    func testPaddedTextFieldPadding() throws {
        // Given
        let textField = PaddedTextField()
        let testText = "Test Text"
        
        // When
        textField.text = testText
        
        // Then
        let textRect = textField.textRect(forBounds: textField.bounds)
        let editingRect = textField.editingRect(forBounds: textField.bounds)
        
        XCTAssertEqual(textRect.origin.x, 10, "Padding esquerdo deve ser aplicado")
        XCTAssertEqual(textRect.width, textField.bounds.width - 20, "Largura deve considerar padding")
        XCTAssertEqual(editingRect.origin.x, 10, "Padding esquerdo deve ser aplicado no editing rect")
        XCTAssertEqual(editingRect.width, textField.bounds.width - 20, "Largura deve considerar padding no editing rect")
    }
    
    func testPaddedTextFieldCustomPadding() throws {
        // Given
        let textField = PaddedTextField()
        textField.padding = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        
        // When
        let textRect = textField.textRect(forBounds: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        // Then
        XCTAssertEqual(textRect.origin.x, 15, "Padding esquerdo customizado deve ser aplicado")
        XCTAssertEqual(textRect.origin.y, 5, "Padding superior customizado deve ser aplicado")
        XCTAssertEqual(textRect.width, 70, "Largura deve considerar padding customizado")
        XCTAssertEqual(textRect.height, 20, "Altura deve considerar padding customizado")
    }
    
    // MARK: - CustomAlert Tests
    
    func testCustomAlertCreation() throws {
        // Given
        let title = "Test Title"
        let message = "Test Message"
        
        // When
        let alert = CustomAlert(title: title, message: message)
        
        // Then
        XCTAssertEqual(alert.title, title, "Título deve ser definido corretamente")
        XCTAssertEqual(alert.message, message, "Mensagem deve ser definida corretamente")
    }
    
    func testCustomAlertUIAlertController() throws {
        // Given
        let title = "Test Title"
        let message = "Test Message"
        let alert = CustomAlert(title: title, message: message)
        
        // When
        let alertController = alert.alert()
        
        // Then
        XCTAssertEqual(alertController.title, title, "Título do alert controller deve ser correto")
        XCTAssertEqual(alertController.message, message, "Mensagem do alert controller deve ser correta")
        XCTAssertEqual(alertController.preferredStyle, .alert, "Estilo deve ser alert")
        XCTAssertEqual(alertController.actions.count, 1, "Deve ter uma ação")
        
        if let action = alertController.actions.first {
            XCTAssertEqual(action.title, "Ok", "Título da ação deve ser 'Ok'")
            XCTAssertEqual(action.style, .default, "Estilo da ação deve ser default")
        }
    }
    
    // MARK: - Colors Tests
    
    func testColorsDefinition() throws {
        // When & Then
        XCTAssertNotNil(Colors.defaultYellow, "Cor amarela padrão deve estar definida")
        XCTAssertNotNil(Colors.darkPrimary, "Cor primária escura deve estar definida")
        XCTAssertNotNil(Colors.darkSecondary, "Cor secundária escura deve estar definida")
    }
    
    func testColorsAreDifferent() throws {
        // When & Then
        XCTAssertNotEqual(Colors.defaultYellow, Colors.darkPrimary, "Cores devem ser diferentes")
        XCTAssertNotEqual(Colors.defaultYellow, Colors.darkSecondary, "Cores devem ser diferentes")
        XCTAssertNotEqual(Colors.darkPrimary, Colors.darkSecondary, "Cores devem ser diferentes")
    }
    
    // MARK: - AuthError Tests
    
    func testAuthErrorCases() throws {
        // When & Then
        XCTAssertEqual(AuthError.invalidCredentials.localizedDescription, "Email ou senha inválidos.")
        XCTAssertEqual(AuthError.userNotFound.localizedDescription, "Usuário não encontrado.")
        XCTAssertEqual(AuthError.unknownError.localizedDescription, "Erro desconhecido. Tente novamente.")
        
        let customMessage = "Custom error message"
        XCTAssertEqual(AuthError.custom(message: customMessage).localizedDescription, customMessage)
    }
    
    // MARK: - Performance Tests
    
    func testSetConstraintsToParentPerformance() throws {
        // Given
        let parentView = UIView()
        let childView = UIView()
        childView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(childView)
        
        // When & Then
        measure {
            childView.setConstraintsToParent(parentView)
        }
    }
    
    func testAddTopBorderPerformance() throws {
        // Given
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // When & Then
        measure {
            view.addTopBorder(to: view, color: .red, height: 2.0)
        }
    }
    
    func testPaddedTextFieldPerformance() throws {
        // Given
        let textField = PaddedTextField()
        textField.text = "Test Text"
        
        // When & Then
        measure {
            _ = textField.textRect(forBounds: textField.bounds)
            _ = textField.editingRect(forBounds: textField.bounds)
        }
    }
}
