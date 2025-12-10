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
    private let clientSecret = "gNEtpCyGP64pIlTYZHMDhhiWb1hVndWr"
    private let refreshToken = "TG-69323f7d4149ba000132312b-3035918550"
    
    // MARK: - Authentication
    func authenticate() -> AnyPublisher<String, NetworkError> {
        guard let url = URL(string: "\(baseURL)/oauth/token") else {
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
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { NetworkError.network($0) }
            .map(\.data)
            .decode(type: AuthToken.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodingError }
            .map { $0.accessToken }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Search with Authentication
    func search(query: String, siteId: String, token: String) -> AnyPublisher<[Product], NetworkError> {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/sites/\(siteId)/search?q=\(encodedQuery)") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { NetworkError.network($0) }
            .map(\.data)
            .decode(type: SearchResponse.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodingError }
            .map(\.results)
            .eraseToAnyPublisher()
    }
    
    func getDetail(id: String) -> AnyPublisher<ProductDetail, NetworkError> {
        guard let url = URL(string: "\(baseURL)/items/\(id)") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { NetworkError.network($0) }
            .map(\.data)
            .decode(type: ProductDetail.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodingError }
            .eraseToAnyPublisher()
    }
    
    func getDescription(id: String) -> AnyPublisher<String?, NetworkError> {
        guard let url = URL(string: "\(baseURL)/items/\(id)/description") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { NetworkError.network($0) }
            .map(\.data)
            .decode(type: ProductDescription.self, decoder: JSONDecoder())
            .map { $0.plainText }
            .catch { _ in Just(nil).setFailureType(to: NetworkError.self) }
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
