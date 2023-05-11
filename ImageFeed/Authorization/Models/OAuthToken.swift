//
//  OAuthToken.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import Foundation

struct OAuthToken: Decodable {
    var accessToken: String
    var tokenType: String
    var refreshToken: String
    var scope: String
    var createdAt: Int

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case scope
        case createdAt = "created_at"
    }
}
