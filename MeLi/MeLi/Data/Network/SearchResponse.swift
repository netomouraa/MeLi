//
//  SearchResponse.swift
//  MeLi
//
//  Created by Neto Moura on 15/12/25.
//

import Foundation

// MARK: - Search Response
struct SearchResponse: Codable {
    let keywords: String?
    let results: [Product]
}
