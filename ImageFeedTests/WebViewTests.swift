//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() throws {
        //Given
        let webViewVC = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        webViewVC.presenter = presenter
        presenter.view = webViewVC

        //When
        let _ = webViewVC.view

        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterCallsLoadRequest() throws {
        //Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let webViewVC = WebViewViewControllerSpy()
        presenter.view = webViewVC
        webViewVC.presenter = presenter

        //When
        presenter.viewDidLoad()

        //Then
        XCTAssertTrue(webViewVC.loadRequestCalled)
    }

    func testProgressVisibleWhenLessThenOne() throws {
        //Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6

        //When
        let isHidden = presenter.shouldHideProgress(for: progress)

        //Then
        XCTAssertFalse(isHidden)
    }

    func testProgressHiddenWhenOne() throws {
        //Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1

        //When
        let isHidden = presenter.shouldHideProgress(for: progress)

        //Then
        XCTAssertTrue(isHidden)
    }

    func testAuthHelperAuthURL() throws {
        //Given
        let config = API.production
        let authHelper = AuthHelper(api: config, urlMaker: .shared)

        //When
        let url = authHelper.authURL()
        let urlString = url.absoluteString

        //Then
        XCTAssertTrue(urlString.contains(config.authUrlString))
        XCTAssertTrue(urlString.contains(config.accessKey))
        XCTAssertTrue(urlString.contains(config.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(config.accessScope))
    }

    func testCodeFromURL() throws {
        //Given
        let authHelper = AuthHelper()
        let urlString = "https://unsplash.com/oauth/authorize/native"
        var urlComponents = URLComponents(string: urlString)
        let queryParams = [URLQueryItem(name: "code", value: "test code")]
        urlComponents?.queryItems = queryParams

        //When
        if let url = urlComponents?.url {
            let code = authHelper.code(from: url)

            //Then
            XCTAssertNotNil(code)
            XCTAssertEqual(code, "test code")
        }

    }

}

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol?
    var viewDidLoadCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {

    }

    func code(from url: URL) -> String? {
        return nil
    }
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var loadRequestCalled = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}
