//
//  ProfileModel.swift
//  ImageFeed
//
//  Created by Денис Максимов on 09.08.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: UserImage
}

struct UserImage: Codable {
    let small: URL?
    let medium: URL?
    let large: URL?
    
    init(small: String,
         medium: String,
         large: String
    ) {
        self.small = URL(string: small)
        self.medium = URL(string: medium)
        self.large = URL(string: large)
    }
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    init(username: String,
         name: String,
         loginName: String,
         bio: String
    ) {
        self.username = username
        self.name = name
        self.loginName = loginName
        self.bio = bio
    }
    
    init (from profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = profileResult.firstName + " " + (profileResult.lastName ?? "")
        self.loginName = "@" + profileResult.username
        self.bio = profileResult.bio  ?? ""
    }
}


