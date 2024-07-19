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
    @IBOutlet private weak var imageOfCell: UIImageView!
    @IBOutlet private weak var bottomGradient: UILabel!  {
        didSet {
            let layerGradient = CAGradientLayer()
            layerGradient.colors = [UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.00).cgColor,
                                    UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.20).cgColor]
            layerGradient.frame = bottomGradient.bounds
            bottomGradient.layer.addSublayer(layerGradient)
        }
    }
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    func configCell(dateFormatter: Formatter, with indexPath: IndexPath, cellImage: UIImage) {
        self.likeButton.imageView?.image = indexPath.row % 2 == 0 ?
                                UIImage(named: "active_like") :
                                UIImage(named: "no_active_like")
        self.dateLabel.text = dateFormatter.string(for: Date())
        self.imageOfCell.image = cellImage
        self.selectionStyle = .none
    }
}
