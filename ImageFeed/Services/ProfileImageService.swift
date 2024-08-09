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

    //MARK: - Methods
    
    private func makeURLRequest(token: String, username: String) -> URLRequest? {
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
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        let request = makeURLRequest(token: token, username: username)
        guard let request else {
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        let task = URLSession.shared.data(for: request) {[weak self] result in
            guard let self else {
                completion(.failure(NetworkErrors.urlSessionError))
                return
            }
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let profileUserResult = try decoder.decode(UserResult.self, from: data)
                    let profileUserImageURL = profileUserResult.profileImage.small
                    self.avatarURL = profileUserImageURL
                    print(profileUserImageURL)
                    completion(.success(profileUserImageURL))
                } catch {
                    print("OAuth token decode error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

}
