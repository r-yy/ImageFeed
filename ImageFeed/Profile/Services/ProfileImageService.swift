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

    private let network = Network.shared
    private let dataTask = URLSession.shared

    private var task: URLSessionTask?

    var imageUrl: String?

    func fetchProfileImage(
        _ username: String,
        token: String,
        completition: @escaping (Result<String,Error>) -> Void
    ) {
        task?.cancel()

        assert(Thread.isMainThread)

        let url = network.getURL(
            withPath: API.usersPath + username,
            baseURL: API.defaultBaseUrl
        )

        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(token))",
            forHTTPHeaderField: "Authorization"
        )

        DispatchQueue.global(qos: .utility).async {
            let task = self.dataTask.dataTask(with: request) {
                data, response, error in
                if
                    let error {
                    completition(.failure(error))
                }

                if
                    let response = response as? HTTPURLResponse,
                    response.statusCode < 200 || response.statusCode > 299 {
                    completition(.failure(FetchError.codeError))
                }

                guard let data else { return }

                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.imageUrl = user.profileImage.small
                    DispatchQueue.main.async {
                        completition(.success(user.profileImage.small))
                    }
                }
                catch let error {
                    assertionFailure("Decoding error: \(error)")
                    completition(.failure(FetchError.codeError))
                }
            }
            self.task = task
            task.resume()
        }
    }
}
