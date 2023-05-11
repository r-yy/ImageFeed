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
        let profileTabBarItem: UITabBarItem = {
            let image = UIImage(systemName: "person.crop.circle.fill")
            let data = image?.pngData()

            let item = UITabBarItem(
                title: nil,
                image: UIImage(data: data ?? Data(), scale: 1.9),
                selectedImage: nil
            )

            return item
        }()
        profileViewController.tabBarItem = profileTabBarItem

        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "rectangle.stack.fill"),
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
