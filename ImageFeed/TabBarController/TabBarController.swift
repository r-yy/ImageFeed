//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 05.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    private let imagesListVC = ImagesListViewController()
    private let profileVC = ProfileViewController()
    private let imagesListPresenter = ImagesListPresenter()
    private let profilePresenter = ProfilePresenter()

    let profileService: ProfileService
    let profileImageService: ProfileImageService

    init(profileService: ProfileService, profileImageService: ProfileImageService) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDependencies()
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
        profileVC.tabBarItem = profileTabBarItem

        imagesListVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "rectangle.stack.fill"),
            selectedImage: nil
        )

        self.viewControllers = [
            imagesListVC,
            profileVC
        ]
    }

    private func customizeTabBar() {
        tabBar.backgroundColor = .ypBlack
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
    }

    private func setDependencies() {
        imagesListVC.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListVC
        profileVC.presenter = profilePresenter
        profilePresenter.view = profileVC
        profilePresenter.profileService = profileService
        profilePresenter.profileImageService = profileImageService
    }
}
