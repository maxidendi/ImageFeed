//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Денис Максимов on 05.07.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var imageOfCell: UIImageView!
    @IBOutlet weak var bottomGradient: UILabel!  {
        didSet {
            let layerGradient = CAGradientLayer()
            layerGradient.colors = [UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.00).cgColor,
                                    UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.20).cgColor]
            layerGradient.frame = bottomGradient.bounds
            bottomGradient.layer.addSublayer(layerGradient)
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
}
