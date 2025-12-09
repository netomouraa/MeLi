//
//  ProductDescription.swift
//  MeLi
//
//  Created by Neto Moura on 09/12/25.
//

import Foundation

struct ProductDescription: Codable {
    let plainText: String
    
    enum CodingKeys: String, CodingKey {
        case plainText = "plain_text"
    }
}

