//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Денис Максимов on 28.07.2024.
//

import Foundation

enum NetworkErrors: Error, LocalizedError {
    case httpsStatusCodeError(Int)
    case urlRequestError(Error)
    case urlSessionError
    
    var errorDescription: String? {
        switch self {
        case .httpsStatusCodeError(let code):
            return "HTTPS Status Code Error: \(code)"
        case .urlRequestError(let error):
            return "URLRequest Error: \(error.localizedDescription)"
        case .urlSessionError:
            return "URLSession Error"
        }
    }
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async{
                completion(result)
            }
        }
        let task = dataTask(with: request) { data, response, error in
            guard let error else {
                guard let data,
                      let response,
                      let statusCode = (response as? HTTPURLResponse)?.statusCode
                else {
                    print(NetworkErrors.urlSessionError.localizedDescription)
                    return fulfillCompletionOnMainThread(
                        .failure(NetworkErrors.urlSessionError))
                }
                guard 200..<300 ~= statusCode
                else {
                    print(NetworkErrors.httpsStatusCodeError(statusCode).localizedDescription)
                    print(String(data: data, encoding: .utf8) as Any)
                    return fulfillCompletionOnMainThread(
                        .failure(NetworkErrors.httpsStatusCodeError(statusCode)))
                }
                return fulfillCompletionOnMainThread(.success(data))
            }
            print(NetworkErrors.urlRequestError(error).localizedDescription)
            fulfillCompletionOnMainThread(.failure(NetworkErrors.urlRequestError(error)))
        }
        return task
    }
}
