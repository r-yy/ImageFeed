//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 22.05.2023.
//

import Foundation

final class ImagesListService {
    private enum NetworkError: Error {
        case codeError
    }
    var photos: [Photo] = []

    weak var delegate: ImagesListDelegate?

    private var task: URLSessionTask?

    private var urlMaker = URLMaker.shared
    private var token = OAuth2TokenStorage.shared
    private var session = URLSession.shared
    private var loadedPage = 1

    //MARK: Upload images list
    func fetchImagesList() {
        assert(Thread.isMainThread)

        task?.cancel()

        let queryParams = [
            URLQueryItem(
                name: "page", value: String(loadedPage)
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
                self.delegate?.showServerErrorAlert()
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    //MARK: Send like action
    func changeLike(
        photoID: String,
        isLiked: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let path = "/\(photoID)/like"

        let url = urlMaker.getURL(
            withPath: API.photosPath + path,
            baseURL: API.defaultBaseUrl
        )

        var request = URLRequest(url: url)
        guard let accessToken = token.keyChainToken else {
            return
        }
        request.setValue(
            "Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization"
        )
        if isLiked {
            request.httpMethod = "DELETE"
        } else {
            request.httpMethod = "POST"
        }

        let task = session.dataTask(with: request) {
            data, response, error in
            DispatchQueue.global(qos: .userInteractive).async {
                if let response = response as? HTTPURLResponse,
                   response.statusCode == 200 || response.statusCode == 201 {
                    DispatchQueue.main.async {
                        self.updateLikesState(photoID: photoID)
                        self.delegate?.syncPhotos()
                        completion(.success(()))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.codeError))
                    }
                }
            }
        }
        task.resume()
    }

    //MARK: Update like state
    private func updateLikesState(photoID: String) {
        guard let index = photos.firstIndex(
            where: { $0.id == photoID }
        ) else {
            return
        }

        let photo = photos[index]

        let newPhoto = Photo(
            id: photo.id,
            size: photo.size,
            createdAt: photo.createdAt,
            welcomeDescription: photo.welcomeDescription,
            smallImageURL: photo.smallImageURL,
            largeImageURL: photo.largeImageURL,
            isLiked: !photo.isLiked
        )

        photos[index] = newPhoto
    }
}
