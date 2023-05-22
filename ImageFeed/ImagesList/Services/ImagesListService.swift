//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 22.05.2023.
//

import Foundation

final class ImagesListService {
    var photos: [Photo] = []
    var loadedPage = 0
    var delegate: ImagesListDelegate?

    private var task: URLSessionTask?

    private var urlMaker = URLMaker.shared
    private var token = OAuth2TokenStorage.shared
    private var session = URLSession.shared

    func fetchImagesList() {
        assert(Thread.isMainThread)

        task?.cancel()

        let currentPage = loadedPage == 0 ? 1 : loadedPage + 1
        let queryParams = [
            URLQueryItem(
                name: "page", value: String(currentPage)
            )
        ]
        let url = urlMaker.getURL(
            withPath: API.photosPath, baseURL: API.defaultBaseUrl
        )
        let urlWithQueryParams = urlMaker.getURL(
            queryParams: queryParams, baseURL: url.absoluteString
        )

        var request = URLRequest(url: urlWithQueryParams)
        guard let accessToken = token.keyChainToken else {
            return
        }
        request.setValue(
            "Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization"
        )

        let task = session.objectTask(for: request) {
            [weak self] (result: Result<[Photo], Error>) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let success):
                self.photos.append(contentsOf: success)
                self.loadedPage += 1
                self.delegate?.addData()
            case .failure:
                assertionFailure()
            }
        }
        task.resume()
        self.task = task
    }
}
