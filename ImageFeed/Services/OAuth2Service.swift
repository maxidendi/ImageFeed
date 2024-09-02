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
        var request = URLRequest(url: url, timeoutInterval: 10)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(
        withCode code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.fetchOAuthToken(withCode: code, completion: completion)
            }
            return
        }
        guard code != lastCode,
              let request = makeOAuthTokenRequest(code: code)
        else {
            NetworkErrors.logError(.invalidRequestError, #file, #function, #line)
            completion(.failure(NetworkErrors.invalidRequestError))
            return
        }
        task?.cancel()
        lastCode = code
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else {
                NetworkErrors.logError(.invalidRequestError, #file, #function, #line)
                completion(.failure(NetworkErrors.invalidRequestError))
                return
            }
            switch result {
            case .success(let response):
                let token = response.accessToken
                completion(.success(token))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
            self.lastCode = nil
        }
        self.task = task
        task.resume()
    }
}
