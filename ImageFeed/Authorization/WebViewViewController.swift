//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 22.04.2023.
//

import WebKit

final class WebViewViewController: BaseViewController {
    private let webView = WKWebView()

    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "darkBack"),
            for: .normal
        )
        button.setTitle(nil, for: .normal)
        button.addTarget(
            self,
            action: #selector(backToAuthVC),
            for: .touchUpInside
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        applyConstraints()
    }

    @objc func backToAuthVC() {
        dismiss(animated: true)
    }
}

extension WebViewViewController {
    private func addSubviews() {
        self.view.addSubview(webView)
        webView.addSubview(backButton)
    }
}

extension WebViewViewController {
    private func applyConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(
                equalTo: self.view.topAnchor
            ),
            webView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor
            ),
            webView.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor
            ),
            webView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor
            ),
            backButton.widthAnchor.constraint(
                equalToConstant: 24
            ),
            backButton.heightAnchor.constraint(
                equalToConstant: 24
            ),
            backButton.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 9
            ),
            backButton.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: 9
            )
        ])
    }
}
