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
    private let showImagesListFlowSegueIdentifier = "ShowImagesListFlow"
    
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
    private func chooseTheFlowToContinue() {
        if OAuth2TokenStorage.shared.token != nil {
            performSegue(withIdentifier: showImagesListFlowSegueIdentifier, sender: nil)
        } else {
            performSegue(withIdentifier: showAuthFlowSegueIdentifier, sender: nil)
        }
    }
}

//MARK: - Extansions

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        dismiss(animated: true)
    }
}
