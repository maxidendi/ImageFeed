//
//  Constants.swift
//  ImageFeed
//
//  Created by Денис Максимов on 25.07.2024.
//

import Foundation

//MARK: - Auth Configuration

struct AuthConfiguration {
    
    //MARK: - Properties
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String
    static var standard: AuthConfiguration {
        return .init(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseURLString: Constants.defaultBaseURLString,
            authURLString: Constants.unsplashAuthorizeURLString)
    }
    
    //MARK: - Init
    
    init(accessKey: String, 
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         defaultBaseURLString: String,
         authURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.authURLString = authURLString
    }
}
