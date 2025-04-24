//
//  AuthError.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 24/04/25.
//
import Foundation

enum AuthError: Error {
    case invalidCredentials
    case userNotFound
    case unknownError
    case custom(message: String)
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials:
            return "Email ou senha inválidos."
        case .userNotFound:
            return "Usuário não encontrado."
        case .unknownError:
            return "Erro desconhecido. Tente novamente."
        case .custom(let message):
            return message
        }
    }
}
