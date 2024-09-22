//
//  ProfileImageServiceStub.swift
//  ImageFeedTests
//
//  Created by Денис Максимов on 22.09.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    
    static let urlStub = URL(string:"https://example.com/avatar.jpg") 
    
    var avatarURL: String? = "https://example.com/avatar.jpg"
    
    func cleanProfileImage() {
        
    }
    
    func fetchProfileImageURL(username: String, token: String, completion: @escaping (Result<String, any Error>) -> Void) {
        
    }
}
