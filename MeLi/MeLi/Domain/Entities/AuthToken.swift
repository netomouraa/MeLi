//
//  AuthToken.swift
//  MeLi
//
//  Created by Neto Moura on 09/12/25.
//

import Foundation

struct AuthToken: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: String
    let userId: Int
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope, userId = "user_id"
        case refreshToken = "refresh_token"
    }
}

