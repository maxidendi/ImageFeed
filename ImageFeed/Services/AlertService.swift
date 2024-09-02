//
//  AlertService.swift
//  ImageFeed
//
//  Created by Денис Максимов on 02.09.2024.
//

import UIKit

final class AlertService {
    
    //MARK: - Init
    
    static let shared = AlertService()
    
    private init() {}
    
    //MARK: - Methods
    
    func showNetworkAlert(on vc: UIViewController, _ completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему(",
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in completion?() })
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    func showNetworkAlertWithRetry(on vc: UIViewController, _ completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать еще раз?",
            preferredStyle: .alert)
        let actionDontTry = UIAlertAction(
            title: "Не надо",
            style: .default)
        alert.addAction(actionDontTry)
        let actionRetry = UIAlertAction(
            title: "Повторить",
            style: .default,
            handler: { _ in completion() })
        alert.addAction(actionRetry)
        vc.present(alert, animated: true)
    }
}
