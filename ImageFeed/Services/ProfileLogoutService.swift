//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Денис Максимов on 02.09.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    
    //MARK: - Init
    
    static let shared = ProfileLogoutService()
    private init() {}
    
    //MARK: - Methods
    
    func logout() {
        cleanCookies()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()
        ) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(
                    ofTypes: record.dataTypes,
                    for: [record],
                    completionHandler: {})
            }
        }
        
        
    }
}
