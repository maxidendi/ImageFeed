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
    
    private var task: URLSessionTask?
    
    private let keyChainStorage = OAuth2KeychainTokenStorage.shared
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    //MARK: - Methods
    
    private func makePhotosNextPageRequest(token: String, page: Int) -> URLRequest? {
        var urlComponents = URLComponents(
            string: Constants.defaultBaseURLString + "/photos")
        urlComponents?.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        guard let url = urlComponents?.url
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchPhotosNextPage() {
        let page = lastLoadedPage + 1

        guard Thread.isMainThread 
        else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.fetchPhotosNextPage()
            }
            return
        }
        guard task == nil,
              let token = keyChainStorage.token,
              let request = makePhotosNextPageRequest(token: token, page: page) 
        else {
            NetworkErrors.logError(.invalidRequestError, file: (#file))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self 
            else {
                NetworkErrors.logError(.invalidRequestError, file: (#file))
                return
            }
            switch result {
            case .success(let photoResult):
                lastLoadedPage = page
                let photos = photoResult.map{ Photo(photoResult: $0) }
                self.photos.append(contentsOf: photos)
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self)
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
