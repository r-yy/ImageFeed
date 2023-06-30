//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    private let urlMaker = URLMaker.shared
    private let api = API.production

    weak var view: WebViewViewControllerProtocol?

    var authHelper: AuthHelperProtocol

    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    func viewDidLoad() {
        let request = authHelper.authRequest()
        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let progressValue = Float(newValue)
        view?.setProgressValue(progressValue)

        let shouldHideProgress = shouldHideProgress(for: progressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.001
    }

    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
