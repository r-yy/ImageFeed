//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Ramil Yanberdin on 01.06.2023.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewTests: XCTestCase {
    func testViewControllerCallsFetchImages() throws {
        //Given
        let imagesListVC = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        imagesListVC.presenter = presenter
        presenter.view = imagesListVC

        //When
        let _ = imagesListVC.view

        //Then
        XCTAssertTrue(presenter.didFetchImagesListCalled)
    }

    func testPresenterCallsShowErrorAlert() throws {
        //Given
        let imagesListVC = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        imagesListVC.presenter = presenter
        presenter.view = imagesListVC

        //When
        presenter.showErrorAlert()

        //Then
        XCTAssertTrue(imagesListVC.didShowErrorAlertCalled)
    }
}

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?

    var photos: [Photo] = []
    var didFetchImagesListCalled = false

    func appendRows() {
        
    }

    func syncPhotos() {

    }

    func fetchImagesList() {
        didFetchImagesListCalled = true
    }

    func cellDidTapLike(cell: ImageFeed.ImagesListCell, completion: @escaping (Result<Bool, Error>) -> Void) {

    }

    func prepare(cell: ImageFeed.ImagesListCell, at row: Int) {

    }

    func shouldUploadNewPage(currentRow: Int) {

    }

    func getCellHeight(at row: Int) -> CGFloat {
        return 1
    }

    func showErrorAlert() {

    }
}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var didShowErrorAlertCalled = false

    var imagesListView: ImagesListView = ImagesListView()

    func insertRows(at: [Int]) {

    }

    func showErrorAlert() {
        didShowErrorAlertCalled = true
    }

    func setCell(cell: ImageFeed.ImagesListCell, imageURL: URL, date: String?, isLiked: Bool) {

    }
}
