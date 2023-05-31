//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.04.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: BaseViewController {
    private var userpicImageView: UIImageView = {
        let view = UIImageView()

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 35

        return view
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypWhite
        label.font = UIFont(
            name: "SF Pro Text Bold", size: 23
        )

        return label
    }()

    private var usernameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypGray
        label.font = UIFont(
            name: "SF Pro Text Regular", size: 13
        )

        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()

        label.textColor = .white
        label.font = UIFont(
            name: "SF Pro Text Regular", size: 13
        )

        return label
    }()

    private let exitButton: UIButton = {
        let button = UIButton()

        button.setImage(
            UIImage(named: "exit"), for: .normal
        )
        button.addTarget(
            nil,
            action: #selector(exitButtonDidTap),
            for: .touchUpInside
        )

        return button
    }()

    private let tokenStorage = OAuth2TokenStorage.shared
    private let alertPresenter = AlertPresenter()

    var profileService: ProfileService?
    var profileImageService: ProfileImageService?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        makeView()
    }

    @objc
    private func exitButtonDidTap() {
        alertPresenter.showExitAlert(vc: self, delegate: self)
    }

    private func updateUI() {
        guard let profile = profileService?.currentProfile,
              let profileImage = profileImageService?.imageUrl
        else { return }
        
        updateProfile(profile: profile, imageURL: profileImage)
    }

    private func updateProfile(profile: Profile, imageURL: String) {
        nameLabel.text = profile.name
        usernameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio

        fetchImage(urlString: imageURL)
    }

    private func fetchImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            assertionFailure("Unable to construct URL: \(urlString)")
            return
        }
        let stubsView = StubsAnimation()
        userpicImageView.kf.setImage(
            with: url,
            placeholder: stubsView
        )
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

extension ProfileViewController {
    private func addSubviews() {
        view.addSubview(userpicImageView)
        view.addSubview(nameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
    }

    private func applyConstraints() {
        userpicImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userpicImageView.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: 22
            ),
            userpicImageView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 18
            ),
            userpicImageView.widthAnchor.constraint(
                equalToConstant: 70
            ),
            userpicImageView.heightAnchor.constraint(
                equalToConstant: 70
            ),
            nameLabel.topAnchor.constraint(
                equalTo: userpicImageView.bottomAnchor,
                constant: 8
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: userpicImageView.leadingAnchor
            ),
            usernameLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 8
            ),
            usernameLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),
            descriptionLabel.topAnchor.constraint(
                equalTo: usernameLabel.bottomAnchor,
                constant: 8
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: usernameLabel.leadingAnchor
            ),
            exitButton.centerYAnchor.constraint(
                equalTo: userpicImageView.centerYAnchor
            ),
            exitButton.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -26
            ),
            exitButton.widthAnchor.constraint(
                equalToConstant: 24
            ),
            exitButton.heightAnchor.constraint(
                equalToConstant: 24
            )

        ])
    }

    private func makeView() {
        addSubviews()
        applyConstraints()
    }
}

extension ProfileViewController: AlertPresenterExitDelegate {
    func exit() {
        tokenStorage.deleteToken()
        WebViewViewController.clean()
        switchToSplashVC()
    }
}
