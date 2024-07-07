//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Денис Максимов on 05.07.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var imageOfCell: UIImageView!
    @IBOutlet weak var bottomGradient: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
}
