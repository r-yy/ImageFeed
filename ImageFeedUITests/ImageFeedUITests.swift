//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Ramil Yanberdin on 01.06.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launch()
    }

    func testAuth() throws {
        app.buttons["Auth"].tap()

        let webView = app.webViews["AuthWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let start = webView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3))
        let finish = webView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("hfvbkmm@gmail.com")
        start.press(forDuration: 0.05, thenDragTo: finish)

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("samsi4-nepmyz-ryzBed\n")

        print(app.debugDescription)

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))

    }

    func testFeed() throws {
        let tablesQuery = app.tables

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)

        let cellToTapLike = tablesQuery.descendants(matching: .cell).element(boundBy: 2)
        cellToTapLike.buttons["LikeButtonOff"].tap()
        sleep(3)

        cellToTapLike.buttons["LikeButtonOn"].tap()
        sleep(2)

        cellToTapLike.tap()
        sleep(5)

        let image = app.scrollViews.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 4)
        sleep(3)

        image.pinch(withScale: 0.3, velocity: 4)
        sleep(3)

        let button = app.scrollViews.buttons["BackButton"]
        button.tap()
        
    }

    func testProfile() throws {
        
    }

}
