//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 26.07.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    //MARK: - Properties
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    //MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let vc = segue.destination as? WebViewViewController else {
                assertionFailure("Invalid segue destination")
                return
            }
            vc.authViewControllerDelegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.ypBlack
    }
}

//MARK: - Extensions

extension AuthViewController: WebViewViewControllerDelegate {
    
    //MARK: - Methods of delegate
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: some code
        webViewViewControllerDidCancel(vc)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.navigationController?.popViewController(animated: true)
    }

}
