//
//  ProductDetail.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation

struct ProductCatalogDetail: Codable {
    let id: String
    let status: String
    let domainId: String?
    let permalink: String?
    let name: String
    let familyName: String?
    let pictures: [ProductPicture]
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case domainId = "domain_id"
        case permalink, name
        case familyName = "family_name"
        case pictures
    }

    var imageUrls: [String] {
        pictures.map { $0.url }
    }

}

struct ProductPicture: Codable, Identifiable {
    let id: String
    let url: String
    
    let suggestedForPicker: [String]?
    let maxWidth: Int?
    let maxHeight: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case suggestedForPicker = "suggested_for_picker"
        case maxWidth = "max_width"
        case maxHeight = "max_height"
    }
}

struct ProductDetail: Codable {
    let price: Double?
    let condition: String?
    let availableQuantity: Int?
    
    enum CodingKeys: String, CodingKey {
        case price
        case condition
        case availableQuantity = "available_quantity"
    }
}

struct ProductDescription: Codable {
    let plainText: String?
    
    enum CodingKeys: String, CodingKey {
        case plainText = "plain_text"
    }
}


