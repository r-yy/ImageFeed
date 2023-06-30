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
    private let urlMaker = URLMaker.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    private let api = API.production

    func fetchAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)

        if lastCode == code { return }
        task?.cancel()
        lastCode = code

        let request = makeAuthTokenRequest(code: code)

        let task = session.objectTask(for: request) { [weak self] (result:
            Result<OAuthToken, Error>) in

            guard let self else { return }

            switch result {
            case .success(let token):
                self.tokenStorage.keyChainToken = token.accessToken
                self.tokenStorage.userDefaultsToken = "saved"

                completion(.success(token.accessToken))
            case .failure:
                completion(.failure(FetchError.codeError))
            }
            self.task = nil
            self.lastCode = nil
        }
        self.task = task
        task.resume()
    }

    private func makeAuthTokenRequest(code: String) -> URLRequest {
        let queryParams = [
            URLQueryItem(name: "client_id", value: api.accessKey),
            URLQueryItem(name: "client_secret", value: api.secretKey),
            URLQueryItem(name: "redirect_uri", value: api.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlMaker.getURL(
            queryParams: queryParams,
            baseURL: api.OAuthTokenURLString
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        return request
    }
}
