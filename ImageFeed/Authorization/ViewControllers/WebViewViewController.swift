//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 22.04.2023.
//

import WebKit

final class WebViewViewController: UIViewController {
    private let webView = WKWebView()

    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.action = #selector(backToAuthVC)
        button.image = UIImage(named: "darkBack")
        return button
    }()

    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = .ypBlack
        progressView.progress = 0.0
        return progressView
    }()

    var delegate: WebViewViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadWebView()
        webView.navigationDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        makeView()
        addObserver()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObserver()
    }

    @objc
    private func backToAuthVC() {
        delegate?.webViewViewControllerDidCandel(self)
    }
}

//MARK: Load WebView
extension WebViewViewController {
    private func getURL() -> URL {
        guard let urlComponents = URLComponents(
            string: API.authUrlString
        ) else {
            assertionFailure("Auth URL is unvailable")
            return URL(string: "about:blank")!
        }

        var composedURL = urlComponents
        composedURL.queryItems = [
            URLQueryItem(
                name: "client_id",
                value: API.accessKey
            ),
            URLQueryItem(
                name: "redirect_uri",
                value: API.redirectURI
            ),
            URLQueryItem(
                name: "response_type",
                value: "code"
            ),
            URLQueryItem(
                name: "scope",
                value: API.acessScope
            )
        ]

        guard let url = composedURL.url else {
            assertionFailure("Unable to construct composed Auth URL")
            return URL(string: "about:blank")!
        }
        return url
    }

    private func loadWebView() {
        let request = URLRequest(url: getURL())
        webView.load(request)
    }
}

//MARK: WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(
                self,
                didAuthenticateWithCode: code
            )
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(
        from navigationAction: WKNavigationAction
    ) -> String? {
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

//MARK: KVO
extension WebViewViewController {
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(
                forKeyPath: keyPath,
                of: object,
                change: change,
                context: context
            )
        }
    }

    private func updateProgress() {
        updateProgressSmoothly(
            to: Float(webView.estimatedProgress),
            duration: 0.8
        )
        progressView.isHidden = abs(progressView.progress - 1.0) <= 0.001
    }

    private func addObserver() {
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
    }

    private func removeObserver() {
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil)
    }

    private func updateProgressSmoothly(
        to value: Float,
        duration: TimeInterval
    ) {
        UIView.animate(withDuration: duration, animations: {
            self.progressView.setProgress(value, animated: true)
        }) {
            _ in
            self.progressView.progress = 1.0
        }
    }
}

//MARK: Make View
extension WebViewViewController {
    private func addSubview() {
        self.view.addSubview(webView)
        webView.addSubview(progressView)
    }

    private func applyConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false

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
            progressView.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor
            ),
            progressView.leadingAnchor.constraint(
                equalTo: webView.leadingAnchor
            ),
            progressView.trailingAnchor.constraint(
                equalTo: webView.trailingAnchor
            )
        ])
    }

    private func preferNavigationBar() {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .black
        backButton.target = self
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.backgroundColor = .clear
    }

    private func makeView() {
        addSubview()
        applyConstraints()
        preferNavigationBar()
    }
}
