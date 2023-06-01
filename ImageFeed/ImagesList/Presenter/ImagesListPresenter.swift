//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    private lazy var imagesListService: ImagesListService = {
        let service = ImagesListService()
        service.presenter = self
        return service
    }()

    private let cellDateFormatter = CellDateFormatter()

    weak var view: ImagesListViewControllerProtocol?

    var photos: [Photo] = []

    func appendRows() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        let rows = Array(oldCount..<newCount)
        syncPhotos()

        if oldCount != newCount {
            view?.insertRows(at: rows)
        }
    }

    func syncPhotos() {
        photos = imagesListService.photos
    }

    func fetchImagesList() {
        imagesListService.fetchImagesList()
    }

    func cellDidTapLike(
        cell: ImagesListCell,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        guard let indexPath = view?.imagesListView.tableView.indexPath(
            for: cell
        ) else { return }
        let photo = photos[indexPath.row]

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

    func prepare(cell: ImagesListCell, at row: Int) {
        let date = cellDateFormatter.getFormattedDate(
            from: photos[row].createdAt
        )
        let url = photos[row].smallImageURL
        let isLiked = photos[row].isLiked

        guard let imageURL = URL(string: url) else {
            return
        }

        view?.setCell(
            cell: cell, imageURL: imageURL, date: date, isLiked: isLiked
        )
    }

    func shouldUploadNewPage(currentRow: Int) {
        if currentRow == photos.count - 1 {
            fetchImagesList()
        }
    }

    func getCellHeight(at row: Int) -> CGFloat {
        guard let view else { return 100 }
        let photo = photos[row]
        let tableViewWidth = view.imagesListView.tableView.bounds.size.width
        let photoWidth = photo.size.width
        let scale = tableViewWidth / photoWidth * 0.9
        return ceil(photo.size.height * scale)
    }

    func showErrorAlert() {
        view?.showErrorAlert()
    }
}
