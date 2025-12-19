//
//  Product.swift
//  MeLi
//
//  Created by Neto Moura on 08/12/25.
//

import Foundation

// MARK: - Product
struct Product: Identifiable, Codable {
    let id: String
    let dateCreated: String?
    let catalogProductId: String?
    let status: String
    let domainId: String?
    let name: String
    let attributes: [ProductAttribute]
    let pictures: [ProductPicture]
    let siteId: String
    let keywords: String?
    let type: String?
    let lastUpdated: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated = "date_created"
        case catalogProductId = "catalog_product_id"
        case status
        case domainId = "domain_id"
        case name
        case attributes
        case pictures
        case siteId = "site_id"
        case keywords
        case type
        case lastUpdated = "last_updated"
    }
        
    var mainImage: String? {
        pictures.first?.url
    }
  
}

// MARK: - Product Attribute
struct ProductAttribute: Codable, Identifiable {
    let id: String
    let name: String
    let valueId: String?
    let valueName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case valueId = "value_id"
        case valueName = "value_name"
    }
}
