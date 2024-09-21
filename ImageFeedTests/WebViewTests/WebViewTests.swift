//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Денис Максимов on 16.09.2024.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let viewController = WebViewViewControllerSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadDidCalled)
    }
    
    func testProgressVisibleWhenLessThanOne() {
        //given
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let progress: Float = Float.random(in: 0..<0.9999)
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let progress: Float = 1
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)

    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authURL()
        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        let authHelper = AuthHelper()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [ URLQueryItem(name: "code", value: "test_code") ]
        guard let url = urlComponents?.url else {
            XCTFail("Auth URL is nil")
            return
        }
        
        //when
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code, "test_code")
    }
}
