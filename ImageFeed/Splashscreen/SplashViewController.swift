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
    private let storage = OAuth2KeychainTokenStorage.shared
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        //TODO: Remove from final build
//        KeychainWrapper.standard.removeAllKeys()
        
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
        let screenLogo = UIImageView(image: UIImage(named: "vector"))
        screenLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(screenLogo)
        screenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        screenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func switchToImagesListFlow() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first
         else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = TabBarController()
    }
    
    private func switchToAuthorizationFlow() {
        guard
            let authNavigationController = UIStoryboard(
            name: "Main",
            bundle: .main).instantiateViewController(identifier: "AuthNavigationController") as? UINavigationController,
            let authViewController = authNavigationController.viewControllers[0] as? AuthViewController
        else {
            assertionFailure("Failed to present AuthViewController")
            return
        }
        authViewController.delegate = self
        authNavigationController.isModalInPresentation = true
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
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.switchToImagesListFlow()
                self.profileImageService.fetchProfileImageURL(username: profile.username, token: token) { _ in }
            case .failure(_):
                //TODO: code to show the error
                break
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
