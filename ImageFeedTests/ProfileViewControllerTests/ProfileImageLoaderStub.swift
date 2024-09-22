//
//  Untitled.swift
//  ImageFeed
//
//  Created by Денис Максимов on 22.09.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileImageLoaderStub: ProfileImageLoaderProtocol {
    
    var validURL: Bool = false
    
    func loadImage(from url: URL, completion: @escaping (Result<Data, any Error>) -> Void) {
        
        if let urlStub = ProfileImageServiceStub.urlStub {
            validURL = (url == urlStub) ? true : false
        }
        
        let mockImage = UIImage(named: "0")
        guard let data = mockImage?.pngData()
        else { return completion(.success(Data()))}
        completion(.success(data))
    }
}
