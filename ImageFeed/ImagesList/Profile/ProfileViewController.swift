//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 09.07.2024.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

protocol ProfileViewControllerProtocol: UIViewController {
    init(presenter: ProfilePresenterProtocol)
    var presenter: ProfilePresenterProtocol { get set }
    
    func configure(_ presenter: ProfilePresenterProtocol)
    func updateProfileDetails(profile: Profile)
    func actualProfileDetails() -> (name: String?, login: String?, description: String?)
    func updateAvatar(data: Data)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    //MARK: - Init
    
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    var presenter: ProfilePresenterProtocol
    
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView(image: UIImage(named: "user_avatar_placeholder"))
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 35
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.backgroundColor = UIColor.ypBlack.cgColor
        return photoImageView
    } ()

    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "arrow_forward") ?? UIImage(),
            target: self,
            action: #selector(didTapLogoutButton))
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.accessibilityIdentifier = "logoutButton"
        logoutButton.tintColor = .ypRed
        return logoutButton
    } ()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = .white
        return nameLabel
    } ()
    
    private lazy var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = .ypGray
        return loginLabel
    } ()
    
    private var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        return descriptionLabel
    } ()
        
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypBlack
        addProfilePhoto()
        addLogoutButton()
        addNameLabel()
        addLoginLabel()
        addDescriptionLabel()
        configure(presenter)
        presenter.viewDidLoad()
    }

    //MARK: - Methods
    
    private func addProfilePhoto() {
        view.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalToConstant: 70),
            photoImageView.heightAnchor.constraint(equalToConstant: 70),
            photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }
    
    private func addLogoutButton() {
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -6),
            logoutButton.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
        ])
    }
    
    private func addNameLabel() {
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameLabel.firstBaselineAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 26)
        ])
    }
    
    private func addLoginLabel() {
        view.addSubview(loginLabel)
        NSLayoutConstraint.activate([
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginLabel.heightAnchor.constraint(equalToConstant: 18),
            loginLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.lastBaselineAnchor, constant: 8)
        ])
    }
    
    private func addDescriptionLabel() {
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8)
        ])
    }
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        presenter.view = self
    }
    
    func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func actualProfileDetails() -> (name: String?, login: String?, description: String?) {
        return (nameLabel.text, loginLabel.text, descriptionLabel.text)
    }
    
    func updateAvatar(data: Data) {
        photoImageView.image = UIImage(data: data)
    }
    
    @objc private func didTapLogoutButton() {
        presenter.viewDidTapLogoutButton()
    }
}
