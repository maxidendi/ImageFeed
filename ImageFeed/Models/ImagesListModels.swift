//
//  ImagesListModels.swift
//  ImageFeed
//
//  Created by Денис Максимов on 29.08.2024.
//

import UIKit

struct LikedPhoto: Codable {
    let photo: PhotoResult
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let urls: UrlsResult
    let description: String?
    var likedByUser: Bool
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: URL?
    let smallImageURL: URL?
    let largeImageURL: URL?
    var isLiked: Bool
    
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = Constants.dateFormatter.date(from: photoResult.createdAt ?? "")
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = URL(string: photoResult.urls.thumb)
        self.smallImageURL = URL(string: photoResult.urls.small)
        self.largeImageURL = URL(string: photoResult.urls.full)
        self.isLiked = photoResult.likedByUser
    }

    init (id: String,
          size: CGSize,
          createdAt: Date?,
          welcomeDescription: String?,
          thumbImageURL: String,
          smallImageURL: String,
          largeImageURL: String,
          isLiked: Bool
    ) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = URL(string: thumbImageURL)
        self.smallImageURL = URL(string: smallImageURL)
        self.largeImageURL = URL(string: largeImageURL)
        self.isLiked = isLiked
    }
}
