//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    var profilePresenter: ProfilePresenterProtocol? { get set }

    func setProfile(profile: Profile, imageURL: URL)
    func switchToSplashVC()
}
