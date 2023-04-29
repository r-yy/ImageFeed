//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 29.04.2023.
//

import UIKit
import ProgressHUD

final class UIBlocingProgressHUD {
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }

    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
