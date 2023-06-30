//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 22.05.2023.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let smallImageURL: String
    let largeImageURL: String
    let isLiked: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case isLiked = "liked_by_user"
        case urls
    }

    private enum URLsCodingKeys: String, CodingKey {
        case small
        case regular
    }

    //MARK: Custom init from decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        let urlsNestedContainer = try container.nestedContainer(
            keyedBy: URLsCodingKeys.self, forKey: .urls
        )

        self.id = try container.decode(String.self, forKey: .id)

        let width = try container.decode(
            Int.self, forKey: .width
        )
        let height = try container.decode(
            Int.self, forKey: .height
        )
        self.size = CGSize(
            width: Double(width), height: Double(height)
        )

        if let date = try? container.decode(
            String.self, forKey: .createdAt) {
            self.createdAt = date
        } else {
            self.createdAt = nil
        }

        welcomeDescription = try container.decode(
            String?.self, forKey: .description
        )
        smallImageURL = try urlsNestedContainer.decode(
            String.self, forKey: .small
        )
        largeImageURL = try urlsNestedContainer.decode(
            String.self, forKey: .regular
        )
        isLiked = try container.decode(
            Bool.self, forKey: .isLiked
        )
    }

    //MARK: System init
    init(
        id: String,
        size: CGSize,
        createdAt: String?,
        welcomeDescription: String?,
        smallImageURL: String,
        largeImageURL: String,
        isLiked: Bool
    ) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.smallImageURL = smallImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}
