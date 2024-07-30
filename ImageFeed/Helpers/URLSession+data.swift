//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Денис Максимов on 28.07.2024.
//

import Foundation

enum NetworkErrors: Error {
    case httpsStatusCodeError(Int)
    case urlRequestError(Error)
    case urlSessionError
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
                    print("Network error:\(NetworkErrors.urlSessionError)")
                    return fulfillCompletionOnMainThread(
                        .failure(NetworkErrors.urlSessionError))
                }
                guard 200..<300 ~= statusCode
                else {
                    print("Network error:\(NetworkErrors.httpsStatusCodeError(statusCode))")
                    print(String(data: data, encoding: .utf8) as Any)
                    return fulfillCompletionOnMainThread(
                        .failure(NetworkErrors.httpsStatusCodeError(statusCode)))
                }
                return fulfillCompletionOnMainThread(.success(data))
            }
            print("Network error:\(NetworkErrors.urlRequestError(error))")
            fulfillCompletionOnMainThread(.failure(NetworkErrors.urlRequestError(error)))
        }
        return task
    }
}
