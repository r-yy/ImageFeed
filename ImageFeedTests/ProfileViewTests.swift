//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsGetProfile() throws {
        //Given
        let profileVC = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        profileVC.presenter = presenter
        presenter.view = profileVC

        //When
        let _ = profileVC.view

        //Then
        XCTAssertTrue(presenter.getProfileCalled)
    }
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var getProfileCalled = false

    func getProfile() {
        getProfileCalled = true
    }

    func exit() {
    }


}
