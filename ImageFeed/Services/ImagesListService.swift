//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Денис Максимов on 29.08.2024.
//

import Foundation
import SwiftKeychainWrapper

final class ImagesListService {
    
    //MARK: - Singletone

    static let shared = ImagesListService()
    
    private init() {}
    
    //MARK: - Properties
    
    private var lastLoadedPage: Int = .zero
    
    private(set) var photos: [Photo] = []
    
    private var nextPageTask: URLSessionTask?
    
    private var likeTask: URLSessionTask?
    
    private let keyChainStorage = OAuth2KeychainTokenStorage.shared
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    //MARK: - Methods
    
    func cleanImagesList() {
        photos = []
        lastLoadedPage = .zero
        nextPageTask?.cancel()
        likeTask?.cancel()
    }
    
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
    
    private func makeIsLikedRequest(token: String, photoID: String, isLike: Bool) -> URLRequest? {
        guard let url = URL(string: Constants.defaultBaseURLString + "/photos/\(photoID)/like")
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url, timeoutInterval: 10)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "POST" : "DELETE"
        return request
    }
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<Void, Error>) -> Void) {
        let page = lastLoadedPage + 1

        guard Thread.isMainThread 
        else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.fetchPhotosNextPage(completion)
            }
            return
        }
        guard nextPageTask == nil,
              let token = keyChainStorage.token,
              let request = makePhotosNextPageRequest(token: token, page: page) 
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
                lastLoadedPage = page
                let photos = photosResult.map{ Photo(photoResult: $0) }
                self.photos.append(contentsOf: photos)
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self)
                let void: Void
                completion(.success(void))
            case .failure(let error):
                completion(.failure(error))
            }
            self.nextPageTask = nil
        }
        self.nextPageTask = task
        task.resume()
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard Thread.isMainThread
        else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.changeLike(photoId: photoId, isLike: isLike, completion)
            }
            return
        }
        guard likeTask == nil,
              let token = keyChainStorage.token,
              let request = makeIsLikedRequest(token: token, photoID: photoId, isLike: isLike)
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
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    photos[index].photoResult.likedByUser = likedPhoto.photo.likedByUser
                }
                let void: Void
                completion(.success(void))
            case .failure(let error):
                completion(.failure(error))
            }
            self.likeTask = nil
        }
        self.likeTask = task
        task.resume()

    }
}
