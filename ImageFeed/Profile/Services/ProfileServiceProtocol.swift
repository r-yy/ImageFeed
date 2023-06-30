//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 01.06.2023.
//

import Foundation

protocol ProfileServiceProtocol {
    var currentProfile: Profile? { get set }

    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    )
}
