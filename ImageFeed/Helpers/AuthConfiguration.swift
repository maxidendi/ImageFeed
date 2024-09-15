//
//  Constants.swift
//  ImageFeed
//
//  Created by Денис Максимов on 25.07.2024.
//

import Foundation

enum Constants {
    static let accessKey = "Xm9yREJzofNOp4fxpYuONdi-7ZwiTh-2r-VVZcV_XrM"
    static let secretKey = "xP9jWM24Ig4-ODmcqEIAmJmz5830HCeKjqLrsZtU5m4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURLString = "https://api.unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let decoder = JSONDecoder()
    static let dateFormatter = ISO8601DateFormatter()
}

struct AuthConfiguration {
    
    //MARK: - Properties
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String
    static var standard: AuthConfiguration {
        return AuthConfiguration(
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
