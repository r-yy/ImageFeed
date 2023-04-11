//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.04.2023.
//

import UIKit

final class ProfileViewController: BaseViewController {
    private var userpicImageView: CircularImageView = {
        let imageView = CircularImageView()

        imageView.image = UIImage(
            named: "myImage"
        )

        return imageView
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()

        label.text = "Рамиль Янбердин"
        label.textColor = .ypWhite
        label.font = UIFont(
            name: "SF Pro Text Bold",
            size: 23
        )

        return label
    }()

    private var usernameLabel: UILabel = {
        let label = UILabel()

        label.text = "@yanram"
        label.textColor = .ypGray
        label.font = UIFont(
            name: "SF Pro Text Regular",
            size: 13
        )

        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()

        label.text = "Hello, world!"
        label.textColor = .white
        label.font = UIFont(
            name: "SF Pro Text Regular",
            size: 13
        )

        return label
    }()

    private let exitButton: UIButton = {
        let button = UIButton()

        button.setImage(
            UIImage(named: "exit"),
            for: .normal
        )

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        applyConstraints()
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
}

extension ProfileViewController {
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
}
