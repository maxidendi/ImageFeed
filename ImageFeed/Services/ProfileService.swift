//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Денис Максимов on 08.08.2024.
//

import Foundation

final class ProfileService {
    
    //MARK: - Singletone

    static let shared = ProfileService()
    private init() {}
    
    //MARK: - Properties
    
    private var task: URLSessionTask?
    private(set) var profile: Profile?

    //MARK: - Methods
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "/me", relativeTo: Constants.defaultBaseURL)
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        guard task == nil else {
            NetworkErrors.logError(.invalidRequestError, file: (#file))
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        let request = makeProfileRequest(token: token)
        guard let request else {
            NetworkErrors.logError(.invalidRequestError, file: (#file))
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else {
                NetworkErrors.logError(.invalidRequestError, file: (#file))
                completion(.failure(NetworkErrors.invalidRequestError))
                return
            }
            switch result {
            case .success(let profileResult):
                    let profile = Profile(profileResult: profileResult)
                    self.profile = profile
                    completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
