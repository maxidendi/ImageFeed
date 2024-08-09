//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Денис Максимов on 27.07.2024.
//

import UIKit


final class OAuth2Service {
    
    //MARK: - Singletone

    static let shared = OAuth2Service()
    private init() {}
    
    //MARK: - Properties
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    //MARK: - Methods
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(
        withCode code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        guard code != lastCode else {
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        task?.cancel()
        lastCode = code
        let request = makeOAuthTokenRequest(code: code)
        guard let request else {
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        let task = URLSession.shared.data(for: request) {[weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let token = response.accessToken
                    completion(.success(token))
                } catch {
                    print("OAuth token decode error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            self?.task = nil
            self?.lastCode = nil
        }
        self.task = task
        task.resume()
    }
}
