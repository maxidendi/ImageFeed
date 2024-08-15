//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Денис Максимов on 08.08.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    //MARK: - Properties
    
    private static var window: UIWindow? {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first
    }
    
    //MARK: - Methods
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
