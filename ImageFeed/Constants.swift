//
//  Constants.swift
//  ImageFeed
//
//  Created by Денис Максимов on 26.09.2024.
//

import Foundation

//MARK: - Constants

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
