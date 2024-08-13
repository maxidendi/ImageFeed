//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 12.08.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    //MARK: - Methods of lifecircle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
