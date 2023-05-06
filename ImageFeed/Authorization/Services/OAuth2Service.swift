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

    private let session = URLSession.shared
    private let network = Network.shared

    func fetchAuthToken(
        code: String,
        completition: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)

        if lastCode == code { return }
        task?.cancel()
        lastCode = code

        let request = makeAuthTokenRequest(code: code)

        let task = session.objectTask(for: request) {
            [weak self] (result: Result<OAuthToken, Error>) in
            guard let self else { return }

            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token.accesToken
                completition(.success(token.accesToken))
                self.task = nil
            case .failure:
                completition(.failure(FetchError.codeError))
                self.lastCode = nil
                return
            }
        }
        self.task = task
        task.resume()
    }

    private func makeAuthTokenRequest(code: String) -> URLRequest {
        let queryParams = [
            URLQueryItem(name: "client_id", value: API.accessKey),
            URLQueryItem(name: "client_secret", value: API.secretKey),
            URLQueryItem(name: "redirect_uri", value: API.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = network.getURL(
            queryParams: queryParams,
            baseURL: API.OAuthTokenURLString
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        return request
    }
}
