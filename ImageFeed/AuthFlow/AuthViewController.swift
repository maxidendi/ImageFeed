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
    
    private let alertPresenter = AlertService.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    private lazy var logo: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "unsplash_logo"))
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    } ()
    
    private lazy var enterButton: UIButton = {
        let enterButton = UIButton(type: .custom)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.setTitle("Войти", for: .normal)
        enterButton.setTitleColor(.ypBlack, for: .normal)
        enterButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        enterButton.backgroundColor = .ypWhite
        enterButton.layer.masksToBounds = true
        enterButton.layer.cornerRadius = 16
        enterButton.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
        return enterButton
    } ()
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addLogo()
        addEnterButton()
        configureBackButton()
    }
    
    //MARK: - Methods
    
    private func addLogo() {
        view.addSubview(logo)
        NSLayoutConstraint.activate([
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 60),
            logo.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func addEnterButton() {
        view.addSubview(enterButton)
        NSLayoutConstraint.activate([
            enterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            enterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            enterButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc private func didTapEnterButton() {
        guard let nc = navigationController else { return }
        let wv = WebViewViewController()
        wv.delegate = self
        nc.pushViewController(wv, animated: true)
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
        DispatchQueue.global().async {
            OAuth2Service.shared.fetchOAuthToken(withCode: code) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self else { return }
                switch result {
                case .success(let token):
                    OAuth2KeychainTokenStorage.shared.token = token
                    delegate?.didAuthenticate(self, with: token)
                case .failure(_):
                    alertPresenter.showNetworkAlert(on: self)
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    }
}

