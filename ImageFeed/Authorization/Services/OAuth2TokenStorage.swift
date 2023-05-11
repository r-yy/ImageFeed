//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    fileprivate let keyChainKey = "KeyChainKey"
    fileprivate let userDefaultsKey = "UserDefaultsKey"

    private let keychainWrapper = KeychainWrapper.standard
    private let userDefaults = UserDefaults.standard

    static let shared = OAuth2TokenStorage()

    var keyChainToken: String? {
        get {
            keychainWrapper.string(forKey: keyChainKey)
        }
        set {
            if let newValue {
                keychainWrapper.set(newValue, forKey: keyChainKey)
            }
        }
    }

    var userDefaultsToken: String? {
        get {
            userDefaults.string(forKey: userDefaultsKey)
        }
        set {
            if let newValue {
                userDefaults.set(newValue, forKey: userDefaultsKey)
            }
        }
    }

    func manageKeyChain() {
        if userDefaultsToken == nil {
            keychainWrapper.removeObject(forKey: keyChainKey)
        }
    }
}
