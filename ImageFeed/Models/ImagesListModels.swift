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
    var photoResult: PhotoResult
    var id: String { photoResult.id }
    var size: CGSize { CGSize(width: photoResult.width, height: photoResult.height) }
    var createdAt: Date? { Constants.dateFormatter.date(from: photoResult.createdAt ?? "") }
    var welcomeDescription: String? { photoResult.description }
    var thumbImageURL: String { photoResult.urls.thumb }
    var smallImageURL: String { photoResult.urls.small }
    var largeImageURL: String { photoResult.urls.full }
    var isLiked: Bool { photoResult.likedByUser }
}
