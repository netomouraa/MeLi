//
//  ProductRepository.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import Combine

// MARK: - Product Status
enum ProductStatus: String {
    case active = "active"
    case paused = "paused"
    case closed = "closed"
    case underReview = "under_review"
    case inactive = "inactive"
}

// MARK: - Product Repository
final class ProductRepository: ProductRepositoryProtocol {
    private let baseURL = "https://api.mercadolibre.com"
    
    private let clientId = "2837149663470888"
    private let clientSecret = "gNEtpCyGP64pllTYZHMDhhIWb1hVndWr"
    private let refreshToken = "TG-69323f7d4149ba000132312b-3035918550"
    
    // MARK: - 1. Authentication
    func authenticate() -> AnyPublisher<String, NetworkError> {
        Logger.logInfo("🔐 Iniciando autenticación...")
        
        guard let url = URL(string: "\(baseURL)/oauth/token") else {
            Logger.logError("URL inválida para autenticación")
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyParams = [
            "grant_type": "refresh_token",
            "client_id": clientId,
            "client_secret": clientSecret,
            "refresh_token": refreshToken
        ]
        
        let bodyString = bodyParams
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        Logger.logRequest(request)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .handleEvents(
                receiveOutput: { data, response in
                    Logger.logResponse(response, data: data, error: nil)
                },
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        Logger.logResponse(nil, data: nil, error: error)
                    }
                }
            )
            .mapError { error in
                Logger.logError("Network error en autenticación: \(error.localizedDescription)")
                return NetworkError.network(error)
            }
            .map(\.data)
            .decode(type: AuthToken.self, decoder: JSONDecoder())
            .mapError { error in
                Logger.logError("Decoding error en autenticación: \(error.localizedDescription)")
                return NetworkError.decodingError
            }
            .map { authToken in
                Logger.logSuccess("Token obtenido: \(authToken.accessToken.prefix(30))...")
                return authToken.accessToken
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - 2. Search (/products/search)
    func search(query: String, siteId: String, status: ProductStatus = .active, token: String) -> AnyPublisher<SearchResponse, NetworkError> {
        Logger.logInfo("🔍 Buscando productos: '\(query)' en sitio: \(siteId) com status: \(status.rawValue)")
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            Logger.logError("Error al codificar query")
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var components = URLComponents(string: "\(baseURL)/products/search")
        components?.queryItems = [
            URLQueryItem(name: "status", value: status.rawValue),
            URLQueryItem(name: "site_id", value: siteId),
            URLQueryItem(name: "q", value: encodedQuery)
        ]
        
        guard let url = components?.url else {
            Logger.logError("URL inválida para búsqueda")
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        Logger.logRequest(request)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .handleEvents(
                receiveOutput: { data, response in
                    Logger.logResponse(response, data: data, error: nil)
                },
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        Logger.logResponse(nil, data: nil, error: error)
                    }
                }
            )
            .mapError { error in
                Logger.logError("Network error en búsqueda: \(error.localizedDescription)")
                return NetworkError.network(error)
            }
            .map(\.data)
            .decode(type: SearchResponse.self, decoder: JSONDecoder())
            .mapError { error in
                Logger.logError("Decoding error en búsqueda: \(error.localizedDescription)")
                return NetworkError.decodingError
            }
            .handleEvents(receiveOutput: { response in
                Logger.logSuccess("Búsqueda completada: \(response.results.count) productos encontrados")
            })
            .eraseToAnyPublisher()
    }
    
    // MARK: - 3. Get Catalog Detail (/products/{id})
    func getCatalogDetail(id: String, token: String) -> AnyPublisher<ProductCatalogDetail, NetworkError> {
        Logger.logInfo("📦 Buscando detalhes do catálogo para ID: \(id) com token.")
        
        guard let url = URL(string: "\(baseURL)/products/\(id)") else {
            Logger.logError("URL inválida para detalhes do catálogo")
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        Logger.logRequest(request)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error in
                Logger.logError("Network error em getCatalogDetail: \(error.localizedDescription)")
                return NetworkError.network(error)
            }
            .map(\.data)
            .decode(type: ProductCatalogDetail.self, decoder: JSONDecoder())
            .mapError { error in
                Logger.logError("Decoding error em getCatalogDetail: \(error.localizedDescription)")
                return NetworkError.decodingError
            }
            .eraseToAnyPublisher()
    }
    
}
