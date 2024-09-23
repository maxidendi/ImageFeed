//
//  Untitled.swift
//  ImageFeed
//
//  Created by Денис Максимов on 22.09.2024.
//

import Foundation
import Kingfisher

protocol ProfileImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class ProfileImageLoader: ProfileImageLoaderProtocol {
    
    func loadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        ImageDownloader.default.downloadImage(with: url) { result in
            switch result {
            case .success(let image):
                completion(.success(image.originalData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
