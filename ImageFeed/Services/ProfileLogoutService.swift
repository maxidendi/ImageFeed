//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Денис Максимов on 02.09.2024.
//

import UIKit
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    
    //MARK: - Init
    
    static let shared = ProfileLogoutService()
    private init() {}
    
    //MARK: - Methods
    
    func logoutAndChangeRootViewController(to viewController: UIViewController) {
        cleanCookies()
        KeychainWrapper.standard.removeAllKeys()
        ProfileService.shared.cleanProfile()
        ProfileImageService.shared.cleanProfileImage()
        ImagesListService.shared.cleanImagesList()
        changeRootViewController(to: viewController)
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
    
    func changeRootViewController(to viewController: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first
         else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = viewController
    }
}
