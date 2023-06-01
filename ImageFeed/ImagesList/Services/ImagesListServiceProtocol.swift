//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 01.06.2023.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get set }
    var presenter: ImagesListPresenterProtocol? { get set }

    func fetchImagesList()
    func changeLike(photoID: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}
