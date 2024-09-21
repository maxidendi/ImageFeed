//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 12.08.2024.
//

import UIKit

final class ImagesTabBarController: UITabBarController {
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
        tabBar.isTranslucent = false
        view.backgroundColor = .ypBlack
        setTabBarControllers()
    }
    
    //MARK: - Methods
    
    private func setTabBarControllers() {
        let presenter = ImagesListPresenter(
            imagesListService: ImagesListService.shared,
            alertPresenter: AlertService.shared)
        let imagesListViewController = ImagesListViewController(presenter: presenter)
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil)
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        viewControllers = [imagesListViewController, profileViewController]
    }
}
