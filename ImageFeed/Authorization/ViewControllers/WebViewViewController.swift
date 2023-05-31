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
    var presenter: WebViewPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        makeView()
        webView.navigationDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        observer?.invalidate()
    }

    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()
        ) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

    @objc
    private func backToAuthVC() {
        delegate?.webViewViewControllerDidCancel(self)
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
        guard let url = navigationAction.request.url else {
            return nil
        }
        return presenter?.code(from: url)
    }
}

//MARK: KVO
extension WebViewViewController {
    func setProgressValue(_ newValue: Float) {
        let duration = 0.8

        UIView.animate(withDuration: duration, animations: {
            self.progressView.setProgress(newValue, animated: true)
        }) {
            _ in
            self.progressView.progress = 1.0
        }
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    private func addObserver() {
        observer = webView.observe(\.estimatedProgress) {
            [weak self] _, _ in
            guard let self else { return }
            self.presenter?.didUpdateProgressValue(
                self.webView.estimatedProgress
            )
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

extension WebViewViewController: WebViewViewControllerProtocol {
    func load(request: URLRequest) {
        webView.load(request)
    }
}
