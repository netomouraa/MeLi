//
//  NetworkError.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case network(Error)
    case decodingError
    case custom(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL inválida."
        case .network(let error): return "Erro de rede: \(error.localizedDescription)"
        case .decodingError: return "Erro ao decodificar a resposta do servidor."
        case .custom(let message): return message
        }
    }
}
