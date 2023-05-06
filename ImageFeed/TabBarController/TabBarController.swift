//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 05.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    private let imagesListViewController = ImagesListViewController()
    private let profileViewController = ProfileViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeTabBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeTabBar()
    }

    private func makeTabBar() {
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "imagesListActive"),
            selectedImage: nil
        )

        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "profileActive"),
            selectedImage: nil
        )

        self.viewControllers = [
            imagesListViewController,
            profileViewController
        ]
    }

    private func customizeTabBar() {
        tabBar.backgroundColor = .ypBlack
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
    }
}
