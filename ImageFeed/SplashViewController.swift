//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 29.07.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    
    func didAuthenticate(_ vc: AuthViewController)
}


final class SplashViewController: UIViewController {
    
    //MARK: - Properties
    
    private let showAuthFlowSegueIdentifier = "ShowAuthFlow"
    
    //MARK: - Methods of lifecircle
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthFlowSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let vc = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthFlowSegueIdentifier)")
                return
            }
            vc.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToImagesListFlow() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first
         else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
        let rootController = tabBarController.instantiateViewController(withIdentifier: "ImagesListAndProfile")
        window.rootViewController = rootController
    }
    
    private func chooseTheFlowToContinue() {
        if OAuth2TokenStorage.shared.token != nil {
            switchToImagesListFlow()
        } else {
            performSegue(withIdentifier: showAuthFlowSegueIdentifier, sender: nil)
        }
    }
}

//MARK: - Extansions

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
}
