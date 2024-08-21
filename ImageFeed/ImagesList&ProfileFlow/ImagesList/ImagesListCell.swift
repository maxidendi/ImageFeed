//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Денис Максимов on 05.07.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    //MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .ypBlack
        clipsToBounds = true
        selectionStyle = .none
        addImageOfCellAndBottomGradientView()
        addDateLadel()
        addLikeButton()
    }
    
    //MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    private var imageOfCell: UIImageView = {
        let imageOfCell = UIImageView()
        imageOfCell.translatesAutoresizingMaskIntoConstraints = false
        imageOfCell.layer.masksToBounds = true
        imageOfCell.layer.cornerRadius = 16
        return imageOfCell
    } ()
    
    private var bottomGradient: UIView = {
        let gradient = UIView()
        gradient.translatesAutoresizingMaskIntoConstraints = false
        return gradient
    } ()
    
    private var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .ypWhite
        return dateLabel
    } ()
    
    private var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(UIImage(named: "active_like"), for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        return likeButton
    } ()
    
    //MARK: - Methods
    
    func configCell(dateFormatter: Formatter, with indexPath: IndexPath, cellImage: UIImage) {
        likeButton.imageView?.image = indexPath.row % 2 == 0 ?
                                UIImage(named: "active_like") :
                                UIImage(named: "no_active_like")
        dateLabel.text = dateFormatter.string(for: Date())
        imageOfCell.image = cellImage
        if bottomGradient.layer.sublayers == nil {
            addBottomGradienLayer()
        }
    }
    
    private func addImageOfCellAndBottomGradientView() {
        contentView.addSubview(imageOfCell)
        imageOfCell.addSubview(bottomGradient)
        imageOfCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        imageOfCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        imageOfCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        imageOfCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
    
    private func addBottomGradienLayer() {
        bottomGradient.widthAnchor.constraint(equalTo: imageOfCell.widthAnchor).isActive = true
        bottomGradient.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bottomGradient.leadingAnchor.constraint(equalTo: imageOfCell.leadingAnchor).isActive = true
        bottomGradient.trailingAnchor.constraint(equalTo: imageOfCell.trailingAnchor).isActive = true
        bottomGradient.bottomAnchor.constraint(equalTo: imageOfCell.bottomAnchor).isActive = true
        layoutIfNeeded()
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [UIColor.ypBlack.withAlphaComponent(0.0).cgColor,
                                UIColor.ypBlack.withAlphaComponent(0.5).cgColor]
        layerGradient.frame = bottomGradient.bounds
        bottomGradient.layer.addSublayer(layerGradient)
    }
    
    private func addDateLadel() {
        imageOfCell.addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: imageOfCell.leadingAnchor, constant: 8).isActive = true
        dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: imageOfCell.trailingAnchor, constant: -8).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: imageOfCell.bottomAnchor, constant: -8).isActive = true
    }
    
    private func addLikeButton() {
        imageOfCell.addSubview(likeButton)
        likeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        likeButton.topAnchor.constraint(equalTo: imageOfCell.topAnchor).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: imageOfCell.trailingAnchor).isActive = true
    }
}
