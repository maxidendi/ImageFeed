//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Денис Максимов on 08.08.2024.
//

import UIKit
import ProgressHUD

final class UIProgressHUD {
    
    //MARK: - Properties
    
    private static var window: UIWindow? {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first
    }
    
    //MARK: - Methods
    
    static func blockingShow() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func blockingDismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
    static func show() {
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        ProgressHUD.dismiss()
    }
}
