//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.05.2023.
//

import Foundation

final class ProfileService: ProfileServiceProtocol {
    private enum FetchError: Error {
        case codeError
    }
    private let urlMaker = URLMaker.shared
    private let session = URLSession.shared
    private let api = API.production

    private var task: URLSessionTask?

    var currentProfile: Profile?

    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        assert(Thread.isMainThread)

        task?.cancel()

        let url = urlMaker.getURL(
            withPath: api.mePath,
            baseURL: api.defaultBaseUrl
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
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
