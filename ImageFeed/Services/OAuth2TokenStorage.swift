//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Денис Максимов on 28.07.2024.
//

import Foundation

final class OAuth2TokenStorage {
    
    //MARK: - Singletone
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    //MARK: - Properties

    private let storage = UserDefaults.standard
    private enum StorageKeys: String {
        case token
    }

    var token: String? {
        get {
            storage.string(forKey: StorageKeys.token.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: StorageKeys.token.rawValue)
        }
    }
}
