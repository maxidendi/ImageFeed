//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Денис Максимов on 22.09.2024.
//

@testable import ImageFeed
import XCTest

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    //MARK: - Properties
    
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    //MARK: - Methods
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateViewWith(profile: Profile) {
      
    }
    
    func updateViewAvatar() {
        
    }
    
    func logoutProfile() {
        
    }
    
    func viewDidTapLogoutButton() {
        
    }
    
    
}
