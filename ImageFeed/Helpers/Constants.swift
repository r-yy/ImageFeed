//
//  Constants.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 21.04.2023.
//

import Foundation

//struct API {
//    static let accessKey = "doLPUOLi1Ypom-FZmM09AlIKUpPkh6oI-dRFhhgqa_Q"
//    static let secretKey = "ZOKm4tVrTxHuEMXVLX8ooSL-zt3Ru6zdhY_NypoOYBY"
//
//    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
//
//    static let acessScope = "public+read_user+write_likes"
//
//
//    static let defaultBaseUrl: URL = {
//        guard let url = URL(string: "https://api.unsplash.com/") else {
//            preconditionFailure("Unsplash API is unavailable")
//        }
//        return url
//    }()
//    static let authUrlString = "https://unsplash.com/oauth/authorize"
//    static let OAuthTokenURLString = "https://unsplash.com/oauth/token"
//
//    static let mePath = "/me"
//    static let usersPath = "/users/"
//}

struct API {
    static let accessKey = "QuzE_8NqRbABPfIWyGFOe4YcOzsLUGWZzDrOoh1pVHs"
    static let secretKey = "oYpAN9FzyKUKvDxITtMWHsRCQ87BX-757xuCkMVNfnA"

    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"

    static let acessScope = "public+read_user+write_likes"


    static let defaultBaseUrl: URL = {
        guard let url = URL(string: "https://api.unsplash.com") else {
            preconditionFailure("Unsplash API is unavailable")
        }
        return url
    }()
    static let authUrlString = "https://unsplash.com/oauth/authorize"
    static let OAuthTokenURLString = "https://unsplash.com/oauth/token"

    static let mePath = "/me"
    static let usersPath = "/users/"
}
