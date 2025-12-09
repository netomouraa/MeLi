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
    
    func search(query: String, siteId: String) -> AnyPublisher<[Product], NetworkError> {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/sites/\(siteId)/search?q=\(encodedQuery)") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
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

