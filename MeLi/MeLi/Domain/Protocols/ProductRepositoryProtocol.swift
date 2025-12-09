//
//  ProductRepositoryProtocol.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation
import Combine

protocol ProductRepositoryProtocol {
    func search(query: String, siteId: String) -> AnyPublisher<[Product], NetworkError>
    func getDetail(id: String) -> AnyPublisher<ProductDetail, NetworkError>
    func getDescription(id: String) -> AnyPublisher<String?, NetworkError>
}

