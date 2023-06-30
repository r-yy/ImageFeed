//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 01.06.2023.
//

import Foundation

protocol ProfileImageServiceProtocol {
    var imageUrl: String? { get set }

    func fetchProfileImage(
        _ username: String,
        token: String,
        completion: @escaping (Result<String,Error>) -> Void
    )
}
