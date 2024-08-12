//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Денис Максимов on 09.08.2024.
//

import Foundation

final class ProfileImageService {
    
    //MARK: - Singletone

    static let shared = ProfileImageService()
    private init() {}

    //MARK: - Properties
    
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")

    //MARK: - Methods
    
    private func makeProfileImageRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: "/users/\(username)", relativeTo: Constants.defaultBaseURL)
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
        _ completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        guard task == nil else {
            NetworkErrors.logError(.invalidRequestError, file: (#file))
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        let request = makeProfileImageRequest(token: token, username: username)
        guard let request else {
            NetworkErrors.logError(.invalidRequestError, file: (#file))
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        let task = URLSession.shared.objectTask(for: request) {[weak self] (result: Result<UserResult, Error>) in
            guard let self else {
                NetworkErrors.logError(.invalidRequestError, file: (#file))
                completion(.failure(NetworkErrors.invalidRequestError))
                return
            }
            switch result {
            case .success(let profileUserResult):
                    let profileImageURL = profileUserResult.profileImage.medium
                    self.avatarURL = profileImageURL
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self)
                    completion(.success(profileImageURL))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

}
