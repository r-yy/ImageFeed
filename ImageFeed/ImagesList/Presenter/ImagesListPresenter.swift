//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var cellDateFormatter = CellDateFormatter()

    weak var view: ImagesListViewControllerProtocol?
    var imagesListService: ImagesListServiceProtocol?

    var photos: [Photo] = []

    func appendRows() {
        guard let imagesListService else { return }
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        let rows = Array(oldCount..<newCount)
        syncPhotos()

        if oldCount != newCount {
            view?.insertRows(at: rows)
        }
    }

    func syncPhotos() {
        guard let imagesListService else { return }
        photos = imagesListService.photos
    }

    func fetchImagesList() {
        guard let imagesListService else { return }
        imagesListService.fetchImagesList()
    }

    func cellDidTapLike(
        index: Int?,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        guard let imagesListService,
              let index else {
            return
        }

        let photo = photos[index]

        imagesListService.changeLike(
            photoID: photo.id, isLiked: photo.isLiked
        ) {
            (result: Result<Void, Error>) in
            switch result {
            case .success:
                completion(.success(!photo.isLiked))
            case .failure:
                self.view?.showErrorAlert()
            }
        }
    }

    func shouldUploadNewPage(currentRow: Int) {
        if currentRow == photos.count - 1 {
            fetchImagesList()
        }
    }

    func showErrorAlert() {
        view?.showErrorAlert()
    }
}
