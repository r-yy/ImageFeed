//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import Foundation

final class OAuth2Service {
    private enum FetchError: Error {
        case codeError
    }

    func fetchAuthToken(
        code: String,
        completition: @escaping (Result<String, Error>) -> Void
    ) {
        guard let urlComponents = URLComponents(
            string: API.OAuthTokenURLString
        ) else {
            assertionFailure("Auth token URL is unvailable")
            return
        }

        var composedURL = urlComponents
        composedURL.queryItems = [
            URLQueryItem(
                name: "client_id",
                value: API.accessKey
            ),
            URLQueryItem(
                name: "client_secret",
                value: API.secretKey
            ),
            URLQueryItem(
                name: "redirect_uri",
                value: API.redirectURI
            ),
            URLQueryItem(
                name: "code",
                value: code
            ),
            URLQueryItem(
                name: "grant_type",
                value: "authorization_code"
            )
        ]

        guard let url = composedURL.url else {
            assertionFailure("Unable to construct composed Auth token URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(
            with: request
        ) { data, response, error in
            if
                let error = error {
                completition(.failure(error))
                return
            }

            if
                let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                completition(.failure(FetchError.codeError))
                return
            }

            guard let data = data else { return }

            do {
                let oAuthToken = try JSONDecoder().decode(OAuthToken.self, from: data)
                OAuth2TokenStorage.shared.token = oAuthToken.accesToken
                completition(.success(oAuthToken.accesToken))
            }
            catch let decodingError {
                assertionFailure("Decoding error: \(decodingError)")
                completition(.failure(FetchError.codeError))
            }
        }
        task.resume()
    }
}
