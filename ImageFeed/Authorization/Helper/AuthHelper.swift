//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import Foundation

final class AuthHelper: AuthHelperProtocol {
    private let urlMaker: URLMaker
    private let api: API

    init(api: API = .production, urlMaker: URLMaker = .shared) {
        self.api = api
        self.urlMaker = urlMaker
    }

    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }

    func code(from url: URL) -> String? {
        guard let urlComponents = URLComponents(string: url.absoluteString),
              urlComponents.path == "/oauth/authorize/native",
              let queryItems = urlComponents.queryItems,
              let codeItem = queryItems.first(where: { $0.name == "code" })
        else {
            return nil
        }

        return codeItem.value
    }

    func authURL() -> URL {
        let queryParams: [URLQueryItem] = [
            URLQueryItem(
                name: "client_id", value: api.accessKey
            ),
            URLQueryItem(
                name: "redirect_uri", value: api.redirectURI
            ),
            URLQueryItem(
                name: "response_type", value: "code"
            ),
            URLQueryItem(
                name: "scope", value: api.accessScope
            )
        ]
        let url = urlMaker.getURL(
            queryParams: queryParams,
            baseURL: api.authUrlString
        )

        return url
    }
}
