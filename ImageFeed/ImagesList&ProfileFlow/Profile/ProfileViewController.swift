//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 09.07.2024.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

final class ProfileViewController: UIViewController {
    
    //MARK: - Properties
    
    private let profile = ProfileService.shared.profile
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView(image: UIImage(named: "user_avatar_placeholder"))
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        return photoImageView
    } ()

    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "arrow_forward") ?? UIImage(),
            target: self,
            action: #selector(didTapLogoutButton))
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.tintColor = .ypRed
        return logoutButton
    } ()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = .white
        nameLabel.text = "Екатерина Новикова"
        return nameLabel
    } ()
    
    private lazy var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = .ypGray
        loginLabel.text = "@ekaterina_nov"
        return loginLabel
    } ()
    
    private var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.text = "Hello, world!"
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
        
        guard let profile else { return }
        updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        updateAvatar()
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
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .ypBlack)
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "user_avatar_placeholder"),
            options: [.processor(processor)]
        )
    }
    
    @objc private func didTapLogoutButton() {
        ProfileLogoutService.shared.logout()
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first
         else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
}
