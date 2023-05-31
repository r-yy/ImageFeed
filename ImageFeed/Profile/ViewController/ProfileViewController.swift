//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.04.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: BaseViewController {
    private let profileView: ProfileView = {
        let view = ProfileView()

        view.exitButton.addTarget(
            nil,
            action: #selector(exitButtonDidTap),
            for: .touchUpInside
        )

        return view
    }()

    var alertPresenter: AlertPresenter?
    var profilePresenter: ProfilePresenterProtocol?

    override func loadView() {
        super.loadView()
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profilePresenter?.getProfile()
    }

    @objc
    private func exitButtonDidTap() {
        alertPresenter = AlertPresenter()

        guard let profilePresenter,
              let alertPresenter else { return }

        alertPresenter.showExitAlert(
            viewController: self, delegate: profilePresenter
        )
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func setProfile(profile: Profile, imageURL: URL) {
        profileView.nameLabel.text = profile.name
        profileView.usernameLabel.text = profile.loginName
        profileView.descriptionLabel.text = profile.bio

        let placeholder = ImagesPlaceholder()

        profileView.userpicImageView.kf.setImage(
            with: imageURL, placeholder: placeholder
        )
    }

    func switchToSplashVC() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Failed to invalid configuration")
            return
        }
        let splashVC = SplashViewController()

        window.rootViewController = splashVC
    }
}
