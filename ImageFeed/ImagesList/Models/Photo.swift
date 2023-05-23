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
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
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
        case thumb
        case full
    }

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

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        if let dateString = try? container.decode(
            String.self, forKey: .createdAt),
           let createdAt = formatter.date(from: dateString) {
            self.createdAt = createdAt
        } else {
            self.createdAt = nil
        }

        welcomeDescription = try container.decode(
            String?.self, forKey: .description
        )
        thumbImageURL = try urlsNestedContainer.decode(
            String.self, forKey: .thumb
        )
        largeImageURL = try urlsNestedContainer.decode(
            String.self, forKey: .full
        )
        isLiked = try container.decode(
            Bool.self, forKey: .isLiked
        )
    }

    init(
        id: String,
        size: CGSize,
        createdAt: Date?,
        welcomeDescription: String?,
        thumpImageURL: String,
        largeImageURL: String,
        isLiked: Bool
    ) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumpImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}
