//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 24.04.2023.
//

import Foundation

protocol WebViewViewControllerDelegate {
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String)
    func webViewViewControllerDidCandel(
        _ vc: WebViewViewController
    )
}
