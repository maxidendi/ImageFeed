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
    
    weak var delegate: ImagesListCellDelegate?
        
    private var layers: Set<CALayer> = []
    
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private lazy var imageOfCell: UIImageView = {
        let imageOfCell = UIImageView()
        imageOfCell.isUserInteractionEnabled = true
        imageOfCell.translatesAutoresizingMaskIntoConstraints = false
        imageOfCell.contentMode = .center
        imageOfCell.backgroundColor = .ypWhiteAlpha50
        imageOfCell.layer.masksToBounds = true
        imageOfCell.layer.cornerRadius = 16
        return imageOfCell
    } ()
    
    private lazy var bottomGradient: UIView = {
        let gradient = UIView()
        gradient.translatesAutoresizingMaskIntoConstraints = false
        return gradient
    } ()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .ypWhite
        return dateLabel
    } ()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(named: "no_active_like"), for: .normal)
        return likeButton
    } ()
    
    //MARK: - Methods
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageOfCell.kf.cancelDownloadTask()
        layers.forEach { $0.removeFromSuperlayer() }
    }
    
    func configCell(
        with photo: Photo,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        likeButton.imageView?.image = photo.isLiked ?
                                UIImage(named: "active_like") :
                                UIImage(named: "no_active_like")
        dateLabel.text = ImagesListCell.dateFormatter.string(for: photo.createdAt)
        imageOfCell.kf.indicatorType = .activity
        imageOfCell.kf.setImage(
            with: URL(string: photo.smallImageURL),
            placeholder: UIImage(named: "image_placeholder")) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(_):
                    if bottomGradient.layer.sublayers == nil {
                        addBottomGradienLayer()
                    }
                    let void: Void
                    completion(.success(void))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let image = isLiked ? UIImage(named: "active_like") :
                              UIImage(named: "no_active_like")
        likeButton.setImage(image, for: .normal)
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
        layers.insert(layerGradient)
        layerGradient.colors = [UIColor.ypBlack.withAlphaComponent(0.0).cgColor,
                                UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
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
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.topAnchor.constraint(equalTo: imageOfCell.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageOfCell.trailingAnchor)
        ])
    }
    
    @objc private func likeButtonClicked() {
        guard let delegate else { return }
        delegate.imagesListCellDidTapLike(self)
    }
}
