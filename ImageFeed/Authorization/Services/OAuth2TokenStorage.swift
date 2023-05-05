//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let keychainWrapper = KeychainWrapper.standard
    fileprivate let key = "OAuth2Token"

    static let shared = OAuth2TokenStorage()

    var token: String? {
        get {
            keychainWrapper.string(forKey: key)
        }
        set {
            guard let newValue else {
                preconditionFailure("Auth token is nil")
            }
            keychainWrapper.set(newValue, forKey: key)
        }
    }
}
