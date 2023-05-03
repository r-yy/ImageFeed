//
//  Network.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.05.2023.
//

import Foundation

final class Network {
    func getURL(withPath: String, baseURL: URL) -> URL {
        if var urlComponents = URLComponents(
            url: baseURL,
            resolvingAgainstBaseURL: false
        ) {
            urlComponents.path = withPath

            guard let url = urlComponents.url else {
                preconditionFailure("Cannot implement \(baseURL) with path \(withPath)")
            }
            return url
        } else {
            preconditionFailure("Cannot implement URLComponents")
        }
    }
}
