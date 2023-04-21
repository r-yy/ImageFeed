//
//  Constants.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 21.04.2023.
//

import Foundation

struct UnsplashAPI {
    let accessKey = "doLPUOLi1Ypom-FZmM09AlIKUpPkh6oI-dRFhhgqa_Q"
    let cecretKey = "ZOKm4tVrTxHuEMXVLX8ooSL-zt3Ru6zdhY_NypoOYBY"

    let redirectURI = "urn:ietf:wg:oauth:2.0:oob"

    let acessScope = "public+read_user+write_likes"

    let defaultBaseUrl: URL = {
        guard let url = URL(string: "https://api.unsplash.com/") else {
            preconditionFailure("Unsplash API is unavailable")
        }
        return url
    }()
}
