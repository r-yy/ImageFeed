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

    private var task: URLSessionTask?
    private var lastCode: String?

    func fetchAuthToken(
        code: String,
        completition: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)

        if lastCode == code { return }
        task?.cancel()
        lastCode = code

        let request = makeAuthTokenRequest(code: code)

        let task = URLSession.shared.dataTask(
            with: request
        ) { data, response, error in
            DispatchQueue.main.async {
                if
                    let error = error {
                    completition(.failure(error))
                    self.lastCode = nil
                    return
                }

                if
                    let response = response as? HTTPURLResponse,
                    response.statusCode < 200 || response.statusCode >= 300 {
                    completition(.failure(FetchError.codeError))
                    self.lastCode = nil
                    return
                }

                guard let data = data else { return }

                do {
                    let oAuthToken = try JSONDecoder().decode(OAuthToken.self, from: data)
                    OAuth2TokenStorage.shared.token = oAuthToken.accesToken
                    completition(.success(oAuthToken.accesToken))
                    self.task = nil
                }
                catch let decodingError {
                    assertionFailure("Decoding error: \(decodingError)")
                    completition(.failure(FetchError.codeError))
                    self.lastCode = nil
                }

            }
        }
        self.task = task
        task.resume()
    }

    private func makeAuthTokenRequest(code: String) -> URLRequest {
        guard let baseURL = URL(string: API.OAuthTokenURLString)
        else { preconditionFailure("Auth token URL is unvailable") }

        let queryItems = [
            URLQueryItem(name: "client_id", value: API.accessKey),
            URLQueryItem(name: "client_secret", value: API.secretKey),
            URLQueryItem(name: "redirect_uri", value: API.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        var urlComponents = URLComponents(
            url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems


        guard let url = urlComponents?.url else {
            preconditionFailure("Unable to construct urlComponents")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        return request
    }
}
