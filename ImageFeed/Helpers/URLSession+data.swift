//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Денис Максимов on 28.07.2024.
//

import Foundation

extension URLSession {
    
    //MARK: - Methods
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    Constants.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let resultValue = try Constants.decoder.decode(T.self, from: data)
                    completion(.success(resultValue))
                } catch {
                    print("""
                        -------------
                        Decode error: \(error)
                        File: \((#file as NSString).lastPathComponent)
                        Function: \(#function)
                        Line: \(#line)
                        Data: \(String(data: data, encoding: .utf8) ?? "")
                        -------------
                        """)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
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
                    NetworkErrors.logError(.urlSessionError, #file, #function, #line)
                    return fulfillCompletionOnMainThread(
                        .failure(NetworkErrors.urlSessionError))
                }
                guard 200..<300 ~= statusCode
                else {
                    NetworkErrors.logError(.httpsStatusCodeError(statusCode), #file, #function, #line)
                    print("Data: \(String(data: data, encoding: .utf8) ?? "")")
                    return fulfillCompletionOnMainThread(
                        .failure(NetworkErrors.httpsStatusCodeError(statusCode)))
                }
                return fulfillCompletionOnMainThread(.success(data))
            }
            NetworkErrors.logError(.urlRequestError(error), #file, #function, #line)
            fulfillCompletionOnMainThread(.failure(NetworkErrors.urlRequestError(error)))
        }
        return task
    }
}
