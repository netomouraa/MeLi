//
//  ProductRepositoryProtocol.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import Combine


protocol ProductRepositoryProtocol {
    func authenticate() -> AnyPublisher<String, NetworkError>
    func search(query: String, siteId: String, token: String) -> AnyPublisher<SearchResponse, NetworkError>
//    func search(query: String, siteId: String, status: ProductStatus, token: String) -> AnyPublisher<SearchResponse, NetworkError>
//    func getDetail(id: String) -> AnyPublisher<ProductDetail, NetworkError>
    func getDescription(id: String) -> AnyPublisher<String?, NetworkError>
    func getCatalogDetail(id: String) -> AnyPublisher<ProductCatalogDetail, NetworkError>
}
