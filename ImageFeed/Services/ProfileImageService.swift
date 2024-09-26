//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Денис Максимов on 09.08.2024.
//

import Foundation

protocol ProfileImageServiceProtocol {
    var avatarURL: URL? { get }
    
    func cleanProfileImage()
    func fetchProfileImageURL(
        username: String,
        token: String,
        completion: @escaping (Result<URL?, Error>) -> Void)
}

final class ProfileImageService: ProfileImageServiceProtocol {
    
    //MARK: - Singletone

    static let shared = ProfileImageService()
    private init() {}

    //MARK: - Properties
    
    private var task: URLSessionTask?
    private(set) var avatarURL: URL?
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")

    //MARK: - Methods
    
    func cleanProfileImage() {
        avatarURL = nil
        task?.cancel()
    }
    
    private func makeProfileImageRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: Constants.defaultBaseURLString + "/users/\(username)")
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchProfileImageURL(
        username: String,
        token: String,
        completion: @escaping (Result<URL?, Error>) -> Void
    ) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                fetchProfileImageURL(username: username, token: token, completion: completion)
            }
            return
        }
        guard task == nil,
              let request = makeProfileImageRequest(token: token, username: username)
        else {
            NetworkErrors.logError(.invalidRequestError, #file, #function, #line)
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else {
                NetworkErrors.logError(.invalidRequestError, #file, #function, #line)
                completion(.failure(NetworkErrors.invalidRequestError))
                return
            }
            switch result {
            case .success(let profileUserResult):
                    let profileImageURL = profileUserResult.profileImage.medium
                    avatarURL = profileImageURL
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self)
                    completion(.success(profileImageURL))
            case .failure(let error):
                NetworkErrors.logError(.otherError(error), #file, #function, #line)
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
