//
//  ProfileView.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import UIKit

final class ProfileView: UIView {
    var userpicImageView: UIImageView = {
        let view = UIImageView()

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 35

        return view
    }()

    var nameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypWhite
        label.font = UIFont(
            name: "SF Pro Text Bold", size: 23
        )

        return label
    }()

    var usernameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypGray
        label.font = UIFont(
            name: "SF Pro Text Regular", size: 13
        )

        return label
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()

        label.textColor = .white
        label.font = UIFont(
            name: "SF Pro Text Regular", size: 13
        )
        label.numberOfLines = 5

        return label
    }()

    let exitButton: UIButton = {
        let button = UIButton()

        button.setImage(
            UIImage(named: "exit"), for: .normal
        )
        button.accessibilityIdentifier = "ExitButton"

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileView {
    private func addSubviews() {
        addSubview(userpicImageView)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(descriptionLabel)
        addSubview(exitButton)
    }

    private func applyConstraints() {
        userpicImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userpicImageView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 22
            ),
            userpicImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
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
                equalTo: trailingAnchor,
                constant: -26
            ),
            exitButton.widthAnchor.constraint(
                equalToConstant: 50
            ),
            exitButton.heightAnchor.constraint(
                equalToConstant: 50
            )

        ])
    }

    private func makeView() {
        addSubviews()
        applyConstraints()
    }
}
