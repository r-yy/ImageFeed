//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    var imagesListService: ImagesListServiceProtocol? { get set }

    func appendRows()
    func syncPhotos()
    func fetchImagesList()
    func cellDidTapLike(cell: ImagesListCell, completion: @escaping (Result<Bool, Error>) -> Void)
    func prepare(cell: ImagesListCell, at row: Int)
    func shouldUploadNewPage(currentRow: Int)
    func getCellHeight(at row: Int) -> CGFloat
    func showErrorAlert()
}
