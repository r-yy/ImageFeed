//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 22.04.2023.
//

import UIKit

final class AuthViewController: BaseViewController {
    private let segueIdentifier = "ShowAuthWebView"

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

    var delegate: AuthViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeView()
    }

    @objc
    private func openWebViewVC() {
        let webViewViewController = WebViewViewController()

        webViewViewController.delegate = self

        webViewViewController.modalPresentationStyle = .fullScreen
        webViewViewController.modalTransitionStyle = .crossDissolve

        self.navigationController?.pushViewController(webViewViewController, animated: true)

    }
}

//MARK: Make View
extension AuthViewController {
    private func addSubview() {
        self.view.addSubview(logoImage)
        self.view.addSubview(authButton)
    }

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

    private func preferNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
    }

    private func preferBackButton() {
        let backButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backButton
    }

    private func makeView() {
        addSubview()
        applyConstraints()
        preferNavigationBar()
        preferBackButton()
    }
}


//MARK: Delegate implementation
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    ) {
        delegate?.authViewController(
            self,
            didAuthenticateWithCode: code
        )
    }

    func webViewViewControllerDidCandel(
        _ vc: WebViewViewController
    ) {
        navigationController?.popViewController(animated: true)
    }
}
