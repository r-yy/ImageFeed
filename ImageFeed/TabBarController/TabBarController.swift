//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 05.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "imagesListActive"),
            selectedImage: nil
        )

        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "ProfileActive"),
            selectedImage: nil
        )

        self.viewControllers = [imagesListViewController, profileViewController]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeUI()
    }

    private func customizeUI() {
        self.tabBar.backgroundColor = .ypBlack
        self.tabBar.barTintColor = .ypBlack
        self.tabBar.tintColor = .ypWhite
        self.tabBar.isTranslucent = false
        self.tabBar.clipsToBounds = true
    }
}
