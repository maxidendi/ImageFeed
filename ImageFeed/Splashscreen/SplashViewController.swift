//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 29.07.2024.
//

import UIKit
import SwiftKeychainWrapper

protocol AuthViewControllerDelegate: AnyObject {
    
    func didAuthenticate(_ vc: AuthViewController, with token: String)
}


final class SplashViewController: UIViewController {
    
    //MARK: - Properties
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    private let storage = OAuth2KeychainTokenStorage.shared
    private let alertPresenter = AlertService.shared
    private lazy var splashLogo: UIImageView = {
        let splashLogo = UIImageView(image: UIImage(named: "vector"))
        splashLogo.translatesAutoresizingMaskIntoConstraints = false
        return splashLogo
    } ()
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addSplashScreenLogo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chooseTheFlowToContinue()
    }
        
    //MARK: - Methods
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func addSplashScreenLogo() {
        view.addSubview(splashLogo)
        NSLayoutConstraint.activate([
            splashLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func switchToImagesListFlow() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first
         else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = ImagesTabBarController()
    }
    
    private func switchToAuthorizationFlow() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        let authNavigationController = UINavigationController(
            rootViewController: authViewController)
        authNavigationController.modalPresentationStyle = .fullScreen
        authNavigationController.modalTransitionStyle = .crossDissolve
        present(authNavigationController, animated: true)
    }
    
    private func chooseTheFlowToContinue() {
        if let token = storage.token {
            fetchProfile(token)
        } else {
            switchToAuthorizationFlow()
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIProgressHUD.show()
        profileService.fetchProfile(token: token) { [weak self] result in
            UIProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let profile):
                switchToImagesListFlow()
                profileImageService.fetchProfileImageURL(
                    username: profile.username,
                    token: token) { _ in }
            case .failure:
                alertPresenter.showNetworkAlert(on: self) { self.chooseTheFlowToContinue() }
            }
        }
    }
}

//MARK: - Extansions

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController, with token: String) {
        dismiss(animated: true)
    }
}
