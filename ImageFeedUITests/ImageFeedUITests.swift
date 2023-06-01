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

        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finish = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        start.press(forDuration: 0.7, thenDragTo: finish)
        sleep(2)

        let cellToTapLike = tablesQuery.descendants(matching: .cell).element(boundBy: 2)
        cellToTapLike.buttons["LikeButton"].tap()
        sleep(3)

        cellToTapLike.buttons["LikeButton"].tap()
        sleep(2)

        cellToTapLike.tap()
        sleep(5)

        let image = app.scrollViews.element(boundBy: 0)
        image.doubleTap()
        sleep(2)

        image.doubleTap()
        sleep(2)

        app.scrollViews.buttons["BackButton"].tap()        
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["Рамиль"].exists)
        XCTAssertTrue(app.staticTexts["@ramyan"].exists)

        app.buttons["ExitButton"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()

        
    }

}
