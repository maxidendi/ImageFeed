//
//  AlertModels.swift
//  ImageFeed
//
//  Created by Денис Максимов on 26.09.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttons: [AlertButton]
}

struct AlertButton {
    let title: String
    var completion: (() -> Void)? = nil
}
