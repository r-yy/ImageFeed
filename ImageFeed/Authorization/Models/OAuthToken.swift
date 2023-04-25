//
//  OAuthToken.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import Foundation

struct OAuthToken: Decodable {
    var access_token: String
    var token_type: String
    var refresh_token: String
    var scope: String
    var created_at: Int
}
