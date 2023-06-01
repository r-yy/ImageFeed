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
        let imagesListService = MockImagesListService()
        imagesListVC.presenter = presenter
        presenter.view = imagesListVC
        presenter.imagesListService = imagesListService
        imagesListVC.presenter = presenter

        //When
        let _ = imagesListVC.view

        //Then
        XCTAssertTrue(presenter.didFetchImagesListCalled)
    }

    func testAddPhotos() throws {
        //Given
        let presenter = ImagesListPresenter()
        let imagesListService = MockImagesListService()
        presenter.imagesListService = imagesListService
        imagesListService.presenter = presenter

        //When
        presenter.fetchImagesList()

        //Then
        XCTAssertEqual(presenter.photos.count, 10)
    }

    func testPresenterCallsAppendRows() throws {
        //Given
        let imagesListVC = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        let imagesListService = MockImagesListService()
        imagesListVC.presenter = presenter
        presenter.view = imagesListVC
        presenter.imagesListService = imagesListService
        imagesListService.presenter = presenter

        //When
        let _ = imagesListVC.view

        //Then
        XCTAssertTrue(presenter.appendRowsCalled)
    }

    func testPresenterCallsSyncPhotos() throws {
        //Given
        let imagesListVC = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        let imagesListService = MockImagesListService()
        imagesListVC.presenter = presenter
        presenter.view = imagesListVC
        presenter.imagesListService = imagesListService
        imagesListService.presenter = presenter

        //When
        let _ = imagesListVC.view

        //Then
        XCTAssertTrue(presenter.syncPhotosCalled)
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

    func testPresenterCallsInsertRows() throws {
        //Given
        let imagesListVC = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        let imagesListService = MockImagesListService()
        imagesListVC.presenter = presenter
        presenter.view = imagesListVC
        presenter.imagesListService = imagesListService
        imagesListService.presenter = presenter

        //When
        presenter.fetchImagesList()

        //Then
        XCTAssertTrue(imagesListVC.insertRowsCalled)
    }
}

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var imagesListService: ImagesListServiceProtocol?
    var view: ImagesListViewControllerProtocol?

    var photos: [Photo] = []
    var didFetchImagesListCalled = false
    var appendRowsCalled = false
    var prepareCalled = false
    var syncPhotosCalled = false

    func appendRows() {
        appendRowsCalled = true
        syncPhotos()
    }

    func syncPhotos() {
        syncPhotosCalled = true
    }

    func fetchImagesList() {
        guard let imagesListService else { return }
        imagesListService.fetchImagesList()
        didFetchImagesListCalled = true
    }

    func cellDidTapLike(
        cell: ImagesListCell, completion: @escaping (Result<Bool, Error>) -> Void
    ) { }

    func prepare(cell: ImageFeed.ImagesListCell, at row: Int) {
        prepareCalled = true
    }

    func shouldUploadNewPage(currentRow: Int) { }

    func getCellHeight(at row: Int) -> CGFloat { return 1 }

    func showErrorAlert() { }
}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var didShowErrorAlertCalled = false
    var insertRowsCalled = false

    var imagesListView: ImagesListView = ImagesListView()

    func insertRows(at: [Int]) {
        insertRowsCalled = true
    }

    func showErrorAlert() {
        didShowErrorAlertCalled = true
    }

    func setCell(
        cell: ImagesListCell, imageURL: URL, date: String?, isLiked: Bool
    ) { }
}

final class MockImagesListService: ImagesListServiceProtocol {
    var photos: [Photo] = []

    var presenter: ImagesListPresenterProtocol?

    func fetchImagesList() {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "MockImagesList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let mockData = try decoder.decode([Photo].self, from: data)
                photos.append(contentsOf: mockData)
                presenter?.appendRows()
            } catch {
                print("Error decoding mock data: \(error)")
            }
        } else {
            print("Couldn't find MockImagesList.json")
        }
    }

    func changeLike(
        photoID: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void
    ) { }
}
