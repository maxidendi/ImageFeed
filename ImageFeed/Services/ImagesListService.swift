//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Денис Максимов on 29.08.2024.
//

import Foundation
import SwiftKeychainWrapper

public protocol ImagesListServiceProtocol {
    var photosProvider: [Photo] { get set }
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<Void, Error>) -> Void)
    func changeLike(
        index: Int,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    
    //MARK: - Singletone

    static let shared = ImagesListService()
    
    private init() {}
    
    //MARK: - Properties
    
    private var lastLoadedPage: Int = 1
    
    private var photos: [Photo] = []
    
    private let queue = DispatchQueue(
        label: "customConcurrentQueue",
        qos: .userInteractive,
        attributes: .concurrent)
    
    var photosProvider: [Photo] {
        get {
            queue.sync {
                photos
            }
        }
        set {
            queue.sync(flags: .barrier) {
                photos = newValue
            }
        }
    }
    
    private var nextPageTask: URLSessionTask?
    
    private var likeTask: URLSessionTask?
    
    private let keyChainStorage = OAuth2KeychainTokenStorage.shared
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    //MARK: - Methods
    
    func cleanImagesList() {
        photosProvider = []
        lastLoadedPage = 1
        nextPageTask?.cancel()
        likeTask?.cancel()
    }
    
    //Make requests
    
    private func makePhotosNextPageRequest(token: String, page: Int) -> URLRequest? {
        var urlComponents = URLComponents(
            string: Constants.defaultBaseURLString + "/photos")
        urlComponents?.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        guard let url = urlComponents?.url
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url, timeoutInterval: 10)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    private func makeIsLikedRequest(token: String, index: Int, isLike: Bool) -> URLRequest? {
        guard let url = URL(string: Constants.defaultBaseURLString + "/photos/\(photos[index].id)/like")
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url, timeoutInterval: 10)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "POST" : "DELETE"
        return request
    }
    
    //Fetching photos and changing likes
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<Void, Error>) -> Void) {
        guard Thread.isMainThread 
        else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                fetchPhotosNextPage(completion)
            }
            return
        }
        guard nextPageTask == nil,
              let token = keyChainStorage.token,
              let request = makePhotosNextPageRequest(token: token, page: lastLoadedPage)
        else {
            NetworkErrors.logError(.invalidRequestError, #file, #function, #line)
            return
        }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self 
            else {
                NetworkErrors.logError(.invalidRequestError, #file, #function, #line)
                return
            }
            switch result {
            case .success(let photosResult):
                let newPhotos = photosResult.map{ Photo(from: $0) }
                photosProvider.append(contentsOf: newPhotos)
                lastLoadedPage += 1
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self)
                let void: Void
                completion(.success(void))
            case .failure(let error):
                NetworkErrors.logError(.otherError(error), #file, #function, #line)
                completion(.failure(error))
            }
            self.nextPageTask = nil
        }
        nextPageTask = task
        task.resume()
    }
    
    func changeLike(
        index: Int,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard Thread.isMainThread
        else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                changeLike(index: index, isLike: isLike, completion)
            }
            return
        }
        guard likeTask == nil,
              let token = keyChainStorage.token,
              let request = makeIsLikedRequest(token: token, index: index, isLike: isLike)
        else {
            NetworkErrors.logError(.invalidRequestError, #file, #function, #line)
            return
        }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikedPhoto, Error>) in
            guard let self
            else {
                NetworkErrors.logError(.invalidRequestError, #file, #function, #line)
                return
            }
            switch result {
            case .success(let likedPhoto):
                photosProvider[index].isLiked = likedPhoto.photo.likedByUser
                let void: Void
                completion(.success(void))
            case .failure(let error):
                NetworkErrors.logError(.otherError(error), #file, #function, #line)
                completion(.failure(error))
            }
            self.likeTask = nil
        }
        likeTask = task
        task.resume()
    }
}
