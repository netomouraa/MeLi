//
//  ProductDetail.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation

struct ProductDetail: Codable {
    let id: String
    let title: String
    let price: Double
    let pictures: [Picture]?
    let condition: String
    let warranty: String?
    let availableQuantity: Int?
    let soldQuantity: Int?
    let permalink: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, pictures, condition, warranty, permalink
        case availableQuantity = "available_quantity"
        case soldQuantity = "sold_quantity"
    }
    
    struct Picture: Codable {
        let url: String
    }
}

