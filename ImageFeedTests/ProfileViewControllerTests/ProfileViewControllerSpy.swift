//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Денис Максимов on 22.09.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {
    
    init(presenter: any ImageFeed.ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var presenter: ProfilePresenterProtocol
    var isAvatarUpdated: Bool = false
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        presenter.view = self
    }
    
    func updateProfileDetails(profile: Profile) {
        
    }
    
    func actualProfileDetails() -> (name: String?, login: String?, description: String?) {
        return (nil, nil, nil)
    }
    
    func updateAvatar(data: Data) {
        isAvatarUpdated = true
    }
    
    
}
