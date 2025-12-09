//
//  Product.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation

struct Product: Identifiable, Codable {
    let id: String
    let title: String
    let price: Double
    let thumbnail: String?
    let condition: String
    let availableQuantity: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, thumbnail, condition
        case availableQuantity = "available_quantity"
    }
}

struct SearchResponse: Codable {
    let results: [Product]
}

