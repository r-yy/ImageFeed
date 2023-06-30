//
//  Constants.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 21.04.2023.
//

import Foundation

struct API {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseUrl: URL
    let authUrlString: String
    let OAuthTokenURLString: String

    let mePath = "/me"
    let usersPath = "/users/"
    let photosPath = "/photos"

    static let production = API(
        accessKey: "fJU-SNaFDZrSAmAxjTOACtBmht7Ri4OFx7MuZE2gYkY",
        secretKey: "Lbz32DeaydPVs_7RgQ3Y7agHZ-xeyDsAXlhxhr5TPQg",
        redirectURI: "urn:ietf:wg:oauth:2.0:oob",
        accessScope: "public+read_user+write_likes",
        defaultBaseUrl: "https://api.unsplash.com",
        authUrlString: "https://unsplash.com/oauth/authorize",
        OAuthTokenURLString: "https://unsplash.com/oauth/token"
    )

    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        defaultBaseUrl: String,
        authUrlString: String,
        OAuthTokenURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope

        if let url = URL(string: "https://api.unsplash.com") {
            self.defaultBaseUrl = url
        } else {
            preconditionFailure("Unsplash API is unavailable")
        }

        self.authUrlString = authUrlString
        self.OAuthTokenURLString = OAuthTokenURLString
    }
}
