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

public struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let urls: UrlsResult
    let description: String?
    var likedByUser: Bool
}

public struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

public struct Photo {
//    var photoResult: PhotoResult
//    var id: String { photoResult.id }
//    var size: CGSize { CGSize(width: photoResult.width, height: photoResult.height) }
//    var createdAt: Date? { Constants.dateFormatter.date(from: photoResult.createdAt ?? "") }
//    var welcomeDescription: String? { photoResult.description }
//    var thumbImageURL: String { photoResult.urls.thumb }
//    var smallImageURL: String { photoResult.urls.small }
//    var largeImageURL: String { photoResult.urls.full }
//    var isLiked: Bool { photoResult.likedByUser }
    var id: String
    var size: CGSize
    var createdAt: Date?
    var welcomeDescription: String?
    var thumbImageURL: String
    var smallImageURL: String
    var largeImageURL: String
    var isLiked: Bool
    
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = Constants.dateFormatter.date(from: photoResult.createdAt ?? "")
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.smallImageURL = photoResult.urls.small
        self.largeImageURL = photoResult.urls.full
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
        self.thumbImageURL = thumbImageURL
        self.smallImageURL = smallImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}
