//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import Foundation

final class OAuth2TokenStorage {
    let userDefaults = UserDefaults.standard
    let key = "OAuth2Token"

    var token: String {
        get {
            guard let token = userDefaults.string(forKey: key) else {
                preconditionFailure("Token is empty")
            }
            return token
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
