//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.05.2023.
//

import Foundation

struct Profile: Decodable {
    var username: String
    var name: String
    var loginName: String
    var bio: String?

    private enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        username = try container.decode(
            String.self,
            forKey: CodingKeys.username
        )

        let firstName = try container.decode(
            String.self,
            forKey: CodingKeys.firstName
        )
        let lastName = try container.decode(
            String.self,
            forKey: CodingKeys.lastName
        )
        name = "\(firstName) \(lastName)"

        loginName = "@\(username)"

        if let bio = try container.decode(
            String?.self,
            forKey: CodingKeys.bio
        ) {
            self.bio = bio
        }
    }
}
