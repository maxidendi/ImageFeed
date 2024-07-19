//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 09.07.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Properties

    private var logoutButton: UIButton?
    private var photoImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginLabel: UILabel?
    private var descriptionLabel: UILabel?
        
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(
            red: 0.10,
            green: 0.11,
            blue: 0.13,
            alpha: 1.00)
        
        addProfilePhoto()
        addLogoutButton()
        addNameLabel()
        addLoginLabel()
        addDescriptionLabel()
    }

    //MARK: - Methods
    
    func addProfilePhoto() {
        let photoImageView = UIImageView(image: UIImage(named: "user_photo"))
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        photoImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        self.photoImageView = photoImageView
    }
    
    func addLogoutButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "arrow_forward")!,
            target: self,
            action: nil)
        logoutButton.tintColor = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -6).isActive = true
        guard let photo = self.photoImageView else {
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
            self.logoutButton = logoutButton
            return
        }
        logoutButton.centerYAnchor.constraint(equalTo: photo.centerYAnchor).isActive = true
        self.logoutButton = logoutButton
    }
    
    func addNameLabel() {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = .white
        nameLabel.text = "Екатерина Новикова"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        guard let photo = self.photoImageView else {
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110).isActive = true
            self.nameLabel = nameLabel
            return
        }
        nameLabel.firstBaselineAnchor.constraint(equalTo: photo.bottomAnchor, constant: 26).isActive = true
        self.nameLabel = nameLabel
    }
    
    func addLoginLabel() {
        let loginLabel = UILabel()
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
        loginLabel.text = "@ekaterina_nov"
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        loginLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        guard let name = self.nameLabel else {
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 136).isActive = true
            self.loginLabel = loginLabel
            return
        }
        loginLabel.topAnchor.constraint(equalTo: name.lastBaselineAnchor, constant: 8).isActive = true
        self.loginLabel = loginLabel
    }
    
    func addDescriptionLabel() {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        guard let login = self.loginLabel else {
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162).isActive = true
            self.descriptionLabel = descriptionLabel
            return
        }
        descriptionLabel.topAnchor.constraint(equalTo: login.bottomAnchor, constant: 8).isActive = true
        self.descriptionLabel = descriptionLabel
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
    }
}
