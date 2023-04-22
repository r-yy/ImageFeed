//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 22.04.2023.
//

import UIKit

final class AuthViewController: BaseViewController {
    private var backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypBlack
        return view
    }()

    private var logoImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logoUnsplash")
        return view
    }()

    private var authButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .ypWhite
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont(
            name: "SF Pro Text Bold",
            size: 17
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubview()
        applyConstraints()
    }
}

extension AuthViewController {
    private func addSubview() {
        self.view.addSubview(backGroundView)
        backGroundView.addSubview(logoImage)
        backGroundView.addSubview(authButton)
    }
}

extension AuthViewController {
    private func applyConstraints() {
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        authButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backGroundView.topAnchor.constraint(
                equalTo: self.view.topAnchor
            ),
            backGroundView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor
            ),
            backGroundView.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor
            ),
            backGroundView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor
            ),
            logoImage.centerXAnchor.constraint(
                equalTo: backGroundView.centerXAnchor
            ),
            logoImage.centerYAnchor.constraint(
                equalTo: backGroundView.centerYAnchor
            ),
            authButton.leadingAnchor.constraint(
                equalTo: backGroundView.leadingAnchor,
                constant: 16
            ),
            authButton.trailingAnchor.constraint(
                equalTo: backGroundView.trailingAnchor,
                constant: -16
            ),
            authButton.bottomAnchor.constraint(
                equalTo: backGroundView.bottomAnchor,
                constant: -124
            ),
            authButton.heightAnchor.constraint(
                equalToConstant: 48
            )
        ])
    }
}
