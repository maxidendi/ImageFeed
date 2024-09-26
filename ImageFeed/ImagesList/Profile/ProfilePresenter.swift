//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Денис Максимов on 21.09.2024.
//

import Foundation

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
        guard let url = profileImageService.avatarURL
        else { return }
        imageloader.loadImageData(from: url) { [weak self] result in
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
        let splashViewController = SplashViewController()
        ProfileLogoutService.shared.logoutAndChangeRootViewController(to: splashViewController)
    }
}
