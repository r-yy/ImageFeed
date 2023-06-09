//
//  ProfilePresenterprotocol.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    var profileService: ProfileServiceProtocol? { get set }
    var profileImageService: ProfileImageServiceProtocol? { get set }

    func getProfile()
    func exit()
}
