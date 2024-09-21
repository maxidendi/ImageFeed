//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Денис Максимов on 16.09.2024.
//

@testable import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var loadDidCalled = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadDidCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
