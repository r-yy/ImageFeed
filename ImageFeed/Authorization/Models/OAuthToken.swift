//
//  OAuthToken.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import Foundation

struct OAuthToken: Decodable {
    var acessToken: String
    var tokenType: String
    var scope: String
    var createdAt: Int
}
