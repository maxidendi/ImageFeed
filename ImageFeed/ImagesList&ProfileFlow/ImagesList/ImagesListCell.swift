//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Денис Максимов on 05.07.2024.
//

import UIKit
import Kingfisher

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
        addImageOfCellAndBottomGradientViews()
        addDateLadel()
        addLikeButton()
    }
    
    //MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private var imageOfCell: UIImageView = {
        let imageOfCell = UIImageView()
        imageOfCell.translatesAutoresizingMaskIntoConstraints = false
        imageOfCell.contentMode = .scaleAspectFill
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
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(named: "active_like"), for: .normal)
        return likeButton
    } ()
    
    //MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageOfCell.kf.cancelDownloadTask()
    }
    
    func configCell(
        at indexPath: IndexPath,
        with photo: Photo,
        _ completion: @escaping () -> Void
    ) {
        likeButton.imageView?.image = indexPath.row % 2 == 0 ?
                                UIImage(named: "active_like") :
                                UIImage(named: "no_active_like")
        dateLabel.text = dateFormatter.string(for: photo.createdAt)
        imageOfCell.kf.setImage(
            with: URL(string: photo.smallImageURL),
            placeholder: UIImage(named: "image_placeholder")) { [weak self] _ in
                guard let self else { return }
                completion()
                if self.bottomGradient.layer.sublayers == nil {
                    self.addBottomGradienLayer()
                }
            }
    }
    
    private func addBottomGradienLayer() {
        NSLayoutConstraint.activate([
            bottomGradient.widthAnchor.constraint(equalTo: imageOfCell.widthAnchor),
            bottomGradient.heightAnchor.constraint(equalToConstant: 30),
            bottomGradient.leadingAnchor.constraint(equalTo: imageOfCell.leadingAnchor),
            bottomGradient.trailingAnchor.constraint(equalTo: imageOfCell.trailingAnchor),
            bottomGradient.bottomAnchor.constraint(equalTo: imageOfCell.bottomAnchor)
        ])
        layoutIfNeeded()
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [UIColor.ypBlack.withAlphaComponent(0.0).cgColor,
                                UIColor.ypBlack.withAlphaComponent(0.5).cgColor]
        layerGradient.frame = bottomGradient.bounds
        bottomGradient.layer.addSublayer(layerGradient)
    }
    
    private func addImageOfCellAndBottomGradientViews() {
        contentView.addSubview(imageOfCell)
        imageOfCell.addSubview(bottomGradient)
        NSLayoutConstraint.activate([
            imageOfCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageOfCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            imageOfCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageOfCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func addDateLadel() {
        imageOfCell.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: imageOfCell.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: imageOfCell.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: imageOfCell.bottomAnchor, constant: -8)
        ])
    }
    
    private func addLikeButton() {
        imageOfCell.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.topAnchor.constraint(equalTo: imageOfCell.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageOfCell.trailingAnchor)
        ])
    }
}
