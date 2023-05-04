//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.05.2023.
//

import Foundation

final class ProfileService {
    private enum FetchError: Error {
        case codeError
    }
    private let network = Network()

    private var task: URLSessionTask?

    private(set) var currentProfile: Profile?

    func fetchProfile(
        _ token: String,
        completition: @escaping (Result<Profile, Error>) -> Void
    ) {
        task?.cancel()

        assert(Thread.isMainThread)

        let url = network.getURL(
            withPath: API.mePath,
            baseURL: API.defaultBaseUrl
        )

        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

            DispatchQueue.global(qos: .userInitiated).async {
                if
                    let error = error {
                    completition(.failure(error))
                    return
                }

                if
                    let response = response as? HTTPURLResponse,
                    response.statusCode < 200 || response.statusCode > 299 {
                    completition(.failure(FetchError.codeError))
                    return
                }

                guard let data else { return }

                do {
                    let profile = try JSONDecoder().decode(
                        Profile.self,
                        from: data
                    )
                    self.currentProfile = profile
                    DispatchQueue.main.async {
                        completition(.success(profile))
                    }
                }
                catch let decodingError {
                    assertionFailure("Decoding error: \(decodingError)")
                    completition(.failure(FetchError.codeError))
                }
            }
        }
        self.task = task
        task.resume()
    }
}
