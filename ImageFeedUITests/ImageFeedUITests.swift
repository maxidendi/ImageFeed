//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Денис Максимов on 22.09.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UITEST"]
        app.launch()
    }
    
    func testAuth() {
        app.buttons["enterButton"].tap()
        let webView = app.webViews["webView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("maxidendi@yandex.ru")
        webView.swipeUp()
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("DeM@ks_1992")
        webView.swipeUp()
        webView.buttons["Login"].tap()
        let tablesQuery = app.tables
        let cell = tablesQuery.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
        
    
    func testFeed() {
        sleep(3)
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 2)
        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        cellToLike.tap()
        sleep(3)
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        app.buttons["navBackButton"].tap()
    }
    
    func testProfile() {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        XCTAssertTrue(app.staticTexts["Denis Maximov"].exists)
        XCTAssertTrue(app.staticTexts["@maxidendi"].exists)
        app.buttons["logoutButton"].tap()
        app.alerts["alert"].buttons["Да"].tap()
        let enterButton = app.buttons["enterButton"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 2))
    }
}
