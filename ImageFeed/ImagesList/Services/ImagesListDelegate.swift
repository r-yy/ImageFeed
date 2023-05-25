//
//  ImagesListDelegate.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 22.05.2023.
//

import Foundation

protocol ImagesListDelegate: AnyObject {
    func addData()
    func cellDidTapLike(cell: ImagesListCell, completion: @escaping (Result<Bool, Error>) -> Void)
    func syncPhotos()
}
