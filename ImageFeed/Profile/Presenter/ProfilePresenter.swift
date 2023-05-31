//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    private let tokenStorage = OAuth2TokenStorage.shared

    var profileService: ProfileService?
    var profileImageService: ProfileImageService?
    
    weak var view: ProfileViewControllerProtocol?

    func getProfile() {
        guard let profile = profileService?.currentProfile,
              let profileImage = profileImageService?.imageUrl,
              let imageURL = URL(string: profileImage)
        else { return }

        view?.setProfile(profile: profile, imageURL: imageURL)
    }

    func exit() {
        tokenStorage.deleteToken()
        WebViewViewController.clean()
        switchToSplashVC()
    }

    private func switchToSplashVC() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Failed to invalid configuration")
            return
        }
        let splashVC = SplashViewController()

        window.rootViewController = splashVC
    }
}
