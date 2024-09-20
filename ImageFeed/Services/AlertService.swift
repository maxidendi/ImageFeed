//
//  AlertService.swift
//  ImageFeed
//
//  Created by Денис Максимов on 02.09.2024.
//

import UIKit

protocol AlertServiceProtocol {
    func showNetworkAlert(on vc: UIViewController?, _ completion: (() -> Void)?)
    
    func showNetworkAlertWithRetry(on vc: UIViewController?, _ completion: @escaping () -> Void)
    
    func showSureToLogout(on vc: UIViewController?, _ completion: @escaping () -> Void)
}

final class AlertService: AlertServiceProtocol {
    
    //MARK: - Init
    
    static let shared = AlertService()
    
    private init() {}
    
    //MARK: - Structs
    
    private struct AlertModel {
        let title: String
        let message: String
        let buttons: [AlertButton]
    }
    
    private struct AlertButton {
        let title: String
        var completion: (() -> Void)? = nil
    }
    
    //MARK: - Methods
    
    private func showAlert(model: AlertModel)  -> UIAlertController {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        model.buttons.forEach { button in
            let action = UIAlertAction(
                title: button.title,
                style: .default,
                handler: { _ in button.completion?() })
            alert.addAction(action)
        }
        return alert
    }
    
    func showNetworkAlert(on vc: UIViewController?, _ completion: (() -> Void)?) {
        let button = AlertButton(
            title: "OK",
            completion: completion)
        let model = AlertModel(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему(",
            buttons: [button])
        vc?.present(showAlert(model: model), animated: true)
    }
    
    func showNetworkAlertWithRetry(on vc: UIViewController?, _ completion: @escaping () -> Void) {
        let firstButton = AlertButton(
            title: "Не надо")
        let secondButton = AlertButton(
            title: "Повторить",
            completion: completion)
        let model = AlertModel(
            title: "Что-то пошло не так",
            message: "Попробовать еще раз?",
            buttons: [firstButton, secondButton])
        vc?.present(showAlert(model: model), animated: true)
    }
    
    func showSureToLogout(on vc: UIViewController?, _ completion: @escaping () -> Void) {
        let firstButton = AlertButton(
            title: "Да",
            completion: completion)
        let secondButton = AlertButton(
            title: "Нет")
        let model = AlertModel(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            buttons: [firstButton, secondButton])
        vc?.present(showAlert(model: model), animated: true)
    }
}
