//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Денис Максимов on 15.09.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    //MARK: - Init
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    //MARK: - Properties
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    
    //MARK: - Methods
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else {
            return
        }
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
