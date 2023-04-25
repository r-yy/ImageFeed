//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    private let key = "OAuth2Token"

    var token: String? {
        get {
            userDefaults.string(forKey: key)
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
