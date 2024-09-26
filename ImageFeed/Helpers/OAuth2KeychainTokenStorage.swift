//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Денис Максимов on 28.07.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2KeychainTokenStorage {
    
    //MARK: - Singletone
    
    static let shared = OAuth2KeychainTokenStorage()
    private init() {}
    
    //MARK: - Properties

    private let storage = KeychainWrapper.standard
    
    private enum StorageKeys: String {
        case token
    }

    var token: String? {
        get {
            storage.string(forKey: StorageKeys.token.rawValue)
        }
        set {
            if let newValue {
                storage.set(newValue, forKey: StorageKeys.token.rawValue)
            }
        }
    }
}
