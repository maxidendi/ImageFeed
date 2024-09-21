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
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    //MARK: - Properties
    
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profile = ProfileService.shared.profile
    
    private let profileImageService = ProfileImageService.shared
    
    //MARK: - Methods
    
    func viewDidLoad() {
        guard let profile else { return }
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
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        ImageDownloader.default.downloadImage(with: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let image):
                let avatarData = image.originalData
                view?.updateAvatar(data: avatarData)
            case .failure:
                break
            }
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
