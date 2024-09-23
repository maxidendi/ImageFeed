//
//  ImagesListServiceStub.swift
//  ImageFeedTests
//
//  Created by Денис Максимов on 20.09.2024.
//

@testable import ImageFeed
import Foundation

final class ImagesListServiceStub: ImagesListServiceProtocol {
    
    var photosProvider: [Photo] = []
    var fetchPhotosNextPageCalled: Bool = false
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<Void, Error>) -> Void) {
        fetchPhotosNextPageCalled = true
        for _ in 0..<10 {
            let photo = Photo(
                id: "",
                size: CGSize(width: 100, height: 100),
                createdAt: Date(),
                welcomeDescription: "",
                thumbImageURL: "",
                smallImageURL: "",
                largeImageURL: "",
                isLiked: false)
            photosProvider.append(photo)
        }
        NotificationCenter.default.post(
            name: ImagesListService.didChangeNotification,
            object: nil)
    }
    
    func changeLike(
        index: Int,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        photosProvider[index].isLiked = isLike
        let void: Void
        completion(.success(void))
    }
    
    
}
