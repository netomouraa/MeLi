//
//  ProductRepository.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import Combine

final class ProductRepository: ProductRepositoryProtocol {
    private let baseURL = "https://api.mercadolibre.com"
    
    private let clientId = "2837149663470888"
    private let clientSecret = "gNEtpCyGP64pllTYZHMDhhIWb1hVndWr"
    private let refreshToken = "TG-69323f7d4149ba000132312b-3035918550"
    
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
    
        func search(query: String, siteId: String, token: String) -> AnyPublisher<SearchResponse, NetworkError> {

            Logger.logInfo("🔍 Buscando productos: '\(query)' en sitio: \(siteId)")

        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            Logger.logError("Error al codificar query")
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var components = URLComponents(string: "\(baseURL)/products/search")
        components?.queryItems = [
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
    

    func getCatalogDetail(id: String) -> AnyPublisher<ProductCatalogDetail, NetworkError> {
        Logger.logInfo("📦 Buscando detalhes do catálogo para ID: \(id)")
        
        guard let url = URL(string: "\(baseURL)/products/\(id)") else {
            Logger.logError("URL inválida para detalhes do catálogo")
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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

    func getItemDetail(id: String) -> AnyPublisher<ProductDetail, NetworkError> {
        Logger.logInfo("💰 Buscando detalhes do item para ID: \(id)")
        
        guard let url = URL(string: "\(baseURL)/items/\(id)") else {
            Logger.logError("URL inválida para detalhes do item")
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                Logger.logError("Network error em getItemDetail: \(error.localizedDescription)")
                return NetworkError.network(error)
            }
            .map(\.data)
            .decode(type: ProductDetail.self, decoder: JSONDecoder())
            .mapError { error in
                Logger.logError("Decoding error em getItemDetail: \(error.localizedDescription)")
                return NetworkError.decodingError
            }
            .eraseToAnyPublisher()
    }
 
    func getDescription(id: String) -> AnyPublisher<String?, NetworkError> {
        Logger.logInfo("📝 Buscando descrição para ID: \(id)")
        
        guard let url = URL(string: "\(baseURL)/items/\(id)/description") else {
            Logger.logError("URL inválida para descrição")
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                Logger.logError("Network error em getDescription: \(error.localizedDescription)")
                return NetworkError.network(error)
            }
            .map(\.data)
            .decode(type: ProductDescription.self, decoder: JSONDecoder())
            .map { $0.plainText }
            .catch { error -> AnyPublisher<String?, NetworkError> in
                Logger.logWarning("Descrição não encontrada ou erro de decodificação. Retornando nil. Erro: \(error.localizedDescription)")
                return Just(nil).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}







enum Logger {
    static func logRequest(_ request: URLRequest) {
        print("\n🔵 ===== REQUEST =====")
        print("📍 URL: \(request.url?.absoluteString ?? "N/A")")
        print("📝 Method: \(request.httpMethod ?? "N/A")")
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("📋 Headers:")
            headers.forEach { print("   \($0.key): \($0.value)") }
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("📦 Body: \(bodyString)")
        }
        print("========================\n")
    }
    
    static func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        print("\n🟢 ===== RESPONSE =====")
        
        if let httpResponse = response as? HTTPURLResponse {
            let statusEmoji = (200...299).contains(httpResponse.statusCode) ? "✅" : "❌"
            print("\(statusEmoji) Status: \(httpResponse.statusCode)")
            
            if !httpResponse.allHeaderFields.isEmpty {
                print("📋 Headers:")
                httpResponse.allHeaderFields.forEach { print("   \($0.key): \($0.value)") }
            }
        }
        
        if let data = data {
            print("📦 Data size: \(data.count) bytes")
            if let json = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("📄 JSON Response:\n\(prettyString)")
            } else if let rawString = String(data: data, encoding: .utf8) {
                print("📄 Raw Response:\n\(rawString.prefix(500))")
            }
        }
        
        if let error = error {
            print("❌ Error: \(error.localizedDescription)")
        }
        
        print("========================\n")
    }
    
    static func logInfo(_ message: String) {
        print("ℹ️ INFO: \(message)")
    }
    
    static func logSuccess(_ message: String) {
        print("✅ SUCCESS: \(message)")
    }
    
    static func logError(_ message: String) {
        print("❌ ERROR: \(message)")
    }
    
    static func logWarning(_ message: String) {
        print("⚠️ WARNING: \(message)")
    }
}
