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
    var cellDateFormatter: CellDateFormatter { get set }

    func appendRows()
    func syncPhotos()
    func fetchImagesList()
    func cellDidTapLike(index: Int?, completion: @escaping (Result<Bool, Error>) -> Void)
    func shouldUploadNewPage(currentRow: Int)
    func showErrorAlert()
}
