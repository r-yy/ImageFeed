//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 22.04.2023.
//

import WebKit

final class WebViewViewController: UIViewController {
    private let webView = WKWebView()
    private let urlMaker = URLMaker.shared

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

    private var observer: NSKeyValueObservation?

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
        observer?.invalidate()
    }

    @objc
    private func backToAuthVC() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

//MARK: Load WebView
extension WebViewViewController {
    private func loadWebView() {
        let queryParams: [URLQueryItem] = [
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
                value: API.accessScope
            )
        ]
        let url = urlMaker.getURL(
            queryParams: queryParams,
            baseURL: API.authUrlString
        )
        let request = URLRequest(url: url)

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
    private func updateProgress() {
        let duration = 0.8
        let progress: Float = Float(webView.estimatedProgress)

        UIView.animate(withDuration: duration, animations: {
            self.progressView.setProgress(progress, animated: true)
        }) {
            _ in
            self.progressView.progress = 1.0
        }

        progressView.isHidden = abs(progressView.progress - 1.0) <= 0.001
    }

    private func addObserver() {
        observer = webView.observe(\.estimatedProgress) {
            [weak self] _, _ in
            guard let self else { return }
            self.updateProgress()
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
