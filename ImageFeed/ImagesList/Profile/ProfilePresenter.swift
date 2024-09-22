//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Денис Максимов on 21.09.2024.
//

import UIKit
import Kingfisher

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func updateViewWith(profile: Profile)
    func updateViewAvatar()
    func logoutProfile()
    func viewDidTapLogoutButton()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    //MARK: - Init
    
    init(imageLoader: ProfileImageLoaderProtocol,
         profile: ProfileServiceProtocol = ProfileService.shared,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared
    ) {
        self.imageloader = imageLoader
        self.profileService = profile
        self.profileImageService = profileImageService
    }
    
    //MARK: - Properties
    
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profileService: ProfileServiceProtocol
    
    private let profileImageService: ProfileImageServiceProtocol
    
    private let alertPresenter = AlertService.shared
    
    private let imageloader: ProfileImageLoaderProtocol
    
    //MARK: - Methods
    
    func viewDidLoad() {
        guard let profile = profileService.profile else { return }
        updateViewWith(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }
                updateViewAvatar()
            }
        updateViewAvatar()
    }
    
    func updateViewWith(profile: Profile) {
        view?.updateProfileDetails(profile: profile)
    }
    
    func updateViewAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        imageloader.loadImage(from: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                view?.updateAvatar(data: data)
            case .failure:
                break
            }
        }
    }
    
    func viewDidTapLogoutButton() {
        alertPresenter.showSureToLogout(on: view) { [weak self] in
            guard let self else { return }
            logoutProfile()
        }
    }
    
    func logoutProfile() {
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
