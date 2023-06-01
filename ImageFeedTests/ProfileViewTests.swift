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

    func testPresenterCallsSetProfile() throws {
        //Given
        let profileVC = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        let profileService = ProfileServiceStub()
        let profileImageService = ProfileImageServiceStub()
        profileVC.presenter = presenter
        presenter.view = profileVC
        presenter.profileService = profileService
        presenter.profileImageService = profileImageService

        //When
        profileService.fetchProfile(String()) { _ in }
        profileImageService.fetchProfileImage(
            profileService.currentProfile!.username, token: String()
        ) { _ in }
        presenter.getProfile()

        //Then
        XCTAssertTrue(profileVC.setProfileCalled)
    }
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var profileService: ProfileServiceProtocol?
    var profileImageService: ProfileImageServiceProtocol?
    var view: ProfileViewControllerProtocol?

    var getProfileCalled = false

    func getProfile() {
        getProfileCalled = true
    }

    func exit() { }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var setProfileCalled = false

    func setProfile(profile: ImageFeed.Profile, imageURL: URL) {
        setProfileCalled = true
    }
}

final class ProfileServiceStub: ProfileServiceProtocol {
    var currentProfile: Profile?

    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(
            forResource: "MockProfile", ofType: "json"
        ) {
            do {
                let data = try Data(contentsOf: URL(filePath: path))
                let mockProfile = try JSONDecoder().decode(
                    Profile.self, from: data
                )
                currentProfile = mockProfile
            }
            catch {
                print("Error decoding mock data: \(error)")
            }
        } else {
            print("Couldn't find MockImagesList.json")
        }
    }
}

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    var imageUrl: String?

    func fetchProfileImage(
        _ username: String, token: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(
            forResource: "MockProfileImage", ofType: "json"
        ) {
            do {
                let data = try Data(contentsOf: URL(filePath: path))
                let mockUser = try JSONDecoder().decode(User.self, from: data)
                imageUrl = mockUser.profileImage.large
            }
            catch {
                print("Error decoding mock data: \(error)")
            }
        } else {
            print("Couldn't find MockImagesList.json")
        }
    }
}
