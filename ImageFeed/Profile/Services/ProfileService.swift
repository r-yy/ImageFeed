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
    private let network = Network.shared
    private let session = URLSession.shared

    private var task: URLSessionTask?

    private(set) var currentProfile: Profile?

    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
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

        let task = session.objectTask(for: request) {
            [weak self] (result: Result<Profile, Error>) in
            guard let self else { return }

            switch result {
            case .success(let profile):
                self.currentProfile = profile
                completion(.success(profile))
            case .failure:
                completion(.failure(FetchError.codeError))
            }
        }
        self.task = task
        task.resume()
    }
}
