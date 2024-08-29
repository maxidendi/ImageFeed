//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Денис Максимов on 29.08.2024.
//

import Foundation

final class ImagesListService {
    
    //MARK: - Singletone

    static let shared = ImagesListService()
    private init() {}
    
    //MARK: - Properties
    
    private var lastLoadedPage: Int = .zero
    private(set) var photos: [Photo] = []
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    //MARK: - Methods
    
    private func makePhotosNextPageRequest(token: String, page: Int) -> URLRequest? {
        guard let urlString = Constants.defaultBaseURL?.absoluteString,
              var urlComponents = URLComponents(string: urlString + "/photos")
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        urlComponents.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        guard var url = urlComponents.url
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchPhotosNextPage(
        token: String,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        lastLoadedPage += 1
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.fetchPhotosNextPage(token: token, completion: completion)
            }
            return
        }
        guard task == nil else {
            NetworkErrors.logError(.invalidRequestError, file: (#file))
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        let request = makePhotosNextPageRequest(token: token, page: lastLoadedPage)
        guard let request else {
            NetworkErrors.logError(.invalidRequestError, file: (#file))
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else {
                NetworkErrors.logError(.invalidRequestError, file: (#file))
                completion(.failure(NetworkErrors.invalidRequestError))
                return
            }
            switch result {
            case .success(let photoResult):
                let photos = photoResult.map{ Photo(photoResult: $0) }
                self.photos.append(contentsOf: photos)
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self)
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()

    }
}
