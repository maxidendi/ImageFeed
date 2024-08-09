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
    
    private func makeURLRequest(token: String) -> URLRequest? {
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
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        let request = makeURLRequest(token: token)
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
                    let profileResult = try decoder.decode(ProfileResult.self, from: data)
                    let profile = Profile(profileResult: profileResult)
                    self.profile = profile
                    completion(.success(profile))
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
