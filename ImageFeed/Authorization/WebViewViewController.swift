//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 22.04.2023.
//

import WebKit

final class WebViewViewController: BaseViewController {
    private let webView = WKWebView()
    private let api = API()
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

    var delegate: WebViewViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        applyConstraints()

        loadWebView()
        webView.navigationDelegate = self
    }

    @objc func backToAuthVC() {
        delegate?.webViewViewControllerDidCandel(self)
    }
}

extension WebViewViewController {
    private func getURL() -> URL {
        guard let urlComponents = URLComponents(string: api.authUrlString) else {
            fatalError("Auth URL is unvailable")
        }

        var composedURL = urlComponents
        composedURL.queryItems = [
            URLQueryItem(name: "client_id", value: api.accessKey),
            URLQueryItem(name: "redirect_uri", value: api.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: api.acessScope)
        ]

        guard let url = composedURL.url else {
            fatalError("Unable to construct composed Auth URL")
        }
        return url
    }

    private func loadWebView() {
        let request = URLRequest(url: getURL())
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    private func webView(
        webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            //TODO: process code
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let queryItems = urlComponents.queryItems,
            let codeItem = queryItems.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
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
