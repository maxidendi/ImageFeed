//
//  File.swift
//  ImageFeedTests
//
//  Created by Денис Максимов on 21.09.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewControllerTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerDidConfigurePresenter() {
        //given
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        
        //when
        viewController.configure(presenter)
        
        //then
        XCTAssertNotNil(presenter.view)
    }

    func testViewControllerUpdatesProfileDetails() {
        //given
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        let profile = Profile(
            username: "username",
            name: "name",
            loginName: "loginName",
            bio: "bio")
        
        //when
        _ = viewController.view
        viewController.updateProfileDetails(profile: profile)
        let details = viewController.actualProfileDetails()
                              
        //then
        XCTAssertEqual(details.name, profile.name)
        XCTAssertEqual(details.login, profile.loginName)
        XCTAssertEqual(details.description, profile.bio)
    }
    
    func testPresenterUpdateViewControllerAvatar() {
        //given
        let profileImageLoader = ProfileImageLoaderStub()
        let presenter = ProfilePresenter(
            imageLoader: profileImageLoader,
            profileImageService: ProfileImageServiceStub())
        let viewController = ProfileViewControllerSpy(presenter: presenter)
        
        //when
        viewController.configure(presenter)
        presenter.updateViewAvatar()
        
        //then
        XCTAssertTrue(viewController.isAvatarUpdated)
        XCTAssertTrue(profileImageLoader.validURL)
    }
}
