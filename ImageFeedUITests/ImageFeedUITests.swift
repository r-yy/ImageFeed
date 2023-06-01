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
        //MARK: Необходимо указать свой логин
        loginTextField.typeText("TYPE HERE")
        start.press(forDuration: 0.05, thenDragTo: finish)

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        //MARK: Необходимо указать свой пароль \n прошу не удалять, нужен для теста
        passwordTextField.typeText("TYPE HERE\n")

        print(app.debugDescription)
        sleep(3)

        let cell = app.tables.descendants(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))

    }

    func testFeed() throws {
        sleep(3)
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finish = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.4))
        start.press(forDuration: 1, thenDragTo: finish)
        sleep(3)

        let cellToTapLike = app.tables.children(matching: .cell).element(boundBy: 1)
        let likeButton = cellToTapLike.buttons["LikeButton"]
        likeButton.tap()
        sleep(3)

        likeButton.tap()
        sleep(2)

        cellToTapLike.tap()
        sleep(5)

        let image = app.scrollViews.element(boundBy: 0)
        image.doubleTap()
        sleep(2)

        image.doubleTap()
        sleep(2)

        app.buttons["BackButton"].tap()
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        //MARK: Необходимо изменить на свои данные
        XCTAssertTrue(app.staticTexts["TYPE HERE"].exists)
        XCTAssertTrue(app.staticTexts["TYPE HERE"].exists)

        app.buttons["ExitButton"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()

        
    }

}
