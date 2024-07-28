//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Денис Максимов on 28.07.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let bearerToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case bearerToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
}
