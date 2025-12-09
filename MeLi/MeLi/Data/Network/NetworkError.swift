//
//  NetworkError.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case network(Error)
    case invalidURL
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .network(let error): return "Error de red: \(error.localizedDescription)"
        case .invalidURL: return "URL inválida"
        case .noData: return "No hay datos disponibles"
        case .decodingError: return "Error al procesar los datos"
        }
    }
}

