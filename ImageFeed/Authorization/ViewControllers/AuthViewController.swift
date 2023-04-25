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

    private var OAuthService: OAuth2Service?
    private var OAuthTokenStorage: OAuth2TokenStorage?

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubview()
        applyConstraints()
    }

    @objc func openWebViewVC() {
        performSegue(withIdentifier: "ShowAuthWebView", sender: self)
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

extension AuthViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard let vc = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare \(segueIdentifier)")
            }
            vc.delegate = self
        } else {
            prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuthService = OAuth2Service()
        OAuthTokenStorage = OAuth2TokenStorage()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }

            self.OAuthService?.fetchAuthToken(code: code) { result in
                switch result {
                case .success(let success):
                    self.OAuthTokenStorage?.token = success
                case .failure(let failure):
                    //TODO: Make alert
                    return
                }
            }
        }
    }

    func webViewViewControllerDidCandel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
