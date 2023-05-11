//
//  UIViewController+topMostViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 07.05.2023.
//

import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presentedVC = self.presentedViewController {
            return presentedVC.topMostViewController()
        }

        if let navController = self as? UINavigationController {
            return navController.visibleViewController?.topMostViewController() ?? self
        }

        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topMostViewController() ?? self
        }

        return self
    }
}
