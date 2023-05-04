//
//  ProfileImage.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 04.05.2023.
//

import Foundation

struct ProfileImage: Decodable {
    let small: String

    enum CodingKeys: String, CodingKey {
        case small
    }
}

struct User: Decodable {
    let profileImage: ProfileImage

    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        let profileImageContainer = try container.nestedContainer(
            keyedBy: ProfileImage.CodingKeys.self,
            forKey: .profileImage
        )
        let small = try profileImageContainer.decode(
            String.self,
            forKey: .small
        )
        profileImage = ProfileImage(small: small)
    }
}
