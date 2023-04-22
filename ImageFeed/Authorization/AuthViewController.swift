//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 22.04.2023.
//

import UIKit

final class AuthViewController: BaseViewController {
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
        button.addTarget(
            self,
            action: #selector(openWebViewVC),
            for: .touchUpInside
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubview()
        applyConstraints()
    }

    @objc func openWebViewVC() {
        performSegue(withIdentifier: "ShowWebView", sender: self)
    }
}

extension AuthViewController {
    private func addSubview() {
        self.view.addSubview(logoImage)
        self.view.addSubview(authButton)
    }
}

extension AuthViewController {
    private func applyConstraints() {
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        authButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(
                equalTo: self.view.centerXAnchor
            ),
            logoImage.centerYAnchor.constraint(
                equalTo: self.view.centerYAnchor
            ),
            authButton.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 16
            ),
            authButton.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -16
            ),
            authButton.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor,
                constant: -124
            ),
            authButton.heightAnchor.constraint(
                equalToConstant: 48
            )
        ])
    }
}
