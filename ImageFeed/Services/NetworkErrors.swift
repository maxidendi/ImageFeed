//
//  NetworkErrors.swift
//  ImageFeed
//
//  Created by Денис Максимов on 12.08.2024.
//

import Foundation


enum NetworkErrors: Error, LocalizedError {
    
    //MARK: - Cases & properties
    
    case httpsStatusCodeError(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequestError

    var errorDescription: String? {
        switch self {
        case .httpsStatusCodeError(let code):
            return "HTTPS Status Code Error: \(code)"
        case .urlRequestError(let error):
            return "URLRequest Error: \(error.localizedDescription)"
        case .urlSessionError:
            return "URLSession Error"
        case .invalidRequestError:
            return "Invalid Request Error"
        }
    }
    
    //MARK: - Methods
    
    static func logError(
        _ error: NetworkErrors,
        _ file: String,
        _ function: String,
        _ line: Int
    ) {
        print("""
            -------------
            NetworkError: \(error.localizedDescription)
            File: \((file as NSString).lastPathComponent)
            Function: \(function)
            Line: \(line)
            -------------
            """)
    }
}
