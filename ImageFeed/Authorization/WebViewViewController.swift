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
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = .ypBlack
        progressView.progress = 0.0
        return progressView
    }()

    var delegate: WebViewViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        applyConstraints()


        loadWebView()
        webView.navigationDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addObserver()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        removeObserver()
    }

    @objc
    func backToAuthVC() {
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
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateProgress() {
        updateProgressSmoothly(to: Float(webView.estimatedProgress), duration: 0.8)
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

    private func updateProgressSmoothly(to value: Float, duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.progressView.setProgress(value, animated: true)
        }) {
            _ in
            self.progressView.progress = 1.0
        }
    }
}

extension WebViewViewController {
    private func addSubviews() {
        self.view.addSubview(webView)
        webView.addSubview(backButton)
        webView.addSubview(progressView)
    }
}

extension WebViewViewController {
    private func applyConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
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
            backButton.widthAnchor.constraint(
                equalToConstant: 30
            ),
            backButton.heightAnchor.constraint(
                equalToConstant: 30
            ),
            backButton.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 5
            ),
            backButton.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor
            ),
            progressView.topAnchor.constraint(
                equalTo: backButton.bottomAnchor
            ),
            progressView.leadingAnchor.constraint(
                equalTo: webView.leadingAnchor
            ),
            progressView.trailingAnchor.constraint(
                equalTo: webView.trailingAnchor
            )
        ])
    }
}
