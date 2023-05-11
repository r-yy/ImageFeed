//
//  ProfileImage.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 04.05.2023.
//

import Foundation

struct ProfileImage: Decodable {
    let large: String

    enum CodingKeys: String, CodingKey {
        case large
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
        let large = try profileImageContainer.decode(
            String.self,
            forKey: .large
        )
        profileImage = ProfileImage(large: large)
    }
}
