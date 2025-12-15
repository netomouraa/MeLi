//
//  ProductRepositoryProtocol.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import Combine

// MARK: - Product Repository Protocol
protocol ProductRepositoryProtocol {
    func authenticate() -> AnyPublisher<String, NetworkError>
    func search(query: String, siteId: String, status: ProductStatus, token: String) -> AnyPublisher<SearchResponse, NetworkError>
    func getCatalogDetail(id: String, token: String) -> AnyPublisher<ProductCatalogDetail, NetworkError>
}
