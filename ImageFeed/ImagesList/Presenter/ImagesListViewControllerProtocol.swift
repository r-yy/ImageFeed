//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    var imagesListView: ImagesListView { get set }

    func insertRows(at: [Int])
    func showErrorAlert()
    func setCell(
        cell: ImagesListCell,
        imageURL: URL,
        date: String?,
        isLiked: Bool
    )
}
