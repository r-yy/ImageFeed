//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 04.05.2023.
//

import Foundation

final class ProfileImageService {
    private enum FetchError: Error {
        case codeError
    }

    private let urlMaker = URLMaker.shared
    private let session = URLSession.shared

    private var task: URLSessionTask?

    var imageUrl: String?

    func fetchProfileImage(
        _ username: String,
        token: String,
        completion: @escaping (Result<String,Error>) -> Void
    ) {
        task?.cancel()

        assert(Thread.isMainThread)

        let url = urlMaker.getURL(
            withPath: API.usersPath + username,
            baseURL: API.defaultBaseUrl
        )

        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(token))",
            forHTTPHeaderField: "Authorization"
        )

        let task = session.objectTask(for: request) {
            [weak self] (result: Result<User, Error>) in
            guard let self else { return }

            switch result {
            case .success(let user):
                self.imageUrl = user.profileImage.large
                completion(.success(user.profileImage.large))
            case .failure:
                completion(.failure(FetchError.codeError))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
