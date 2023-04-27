//
//  OAuthToken.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import Foundation

struct OAuthToken: Decodable {
    var accesToken: String
    var tokenType: String
    var refreshToken: String
    var scope: String
    var createdAt: Int

    private enum CodingKeys: String, CodingKey {
        case accesToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case scope
        case createdAt = "created_at"
    }
}
