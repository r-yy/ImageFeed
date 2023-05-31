//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    private let tokenStorage = OAuth2TokenStorage.shared
    private let alertPresenter = AlertPresenter()

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
}

extension ProfilePresenter: AlertPresenterExitDelegate {
    func exit() {
        tokenStorage.deleteToken()
        WebViewViewController.clean()
        view?.switchToSplashVC()
    }
}
