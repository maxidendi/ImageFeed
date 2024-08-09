//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 26.07.2024.
//

import UIKit
import ProgressHUD

protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}


final class AuthViewController: UIViewController {
    
    //MARK: - Properties
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    //MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let vc = segue.destination as? WebViewViewController 
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            vc.delegate = self
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
    
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    ) {        
        navigationController?.popToRootViewController(animated: true)
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(withCode: code) {[weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                print("Actual token: \(token)")
                self.delegate?.didAuthenticate(self, with: token)
            case .failure(_):
                //TODO: code to handle error
                break
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        //TODO: sprint 11
    }

}

