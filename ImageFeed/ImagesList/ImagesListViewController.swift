//
//  ViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 04.07.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private let photosName: [String] = Array(0..<20).map({"\($0)"})
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.00).cgColor,
                                UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.20).cgColor]
        layerGradient.frame = cell.bottomGradient.bounds
        cell.bottomGradient.layer.addSublayer(layerGradient)
        
        cell.likeButton.imageView?.image = indexPath.row % 2 == 0 ?
                                UIImage(named: "ActiveLike") :
                                UIImage(named: "NoActiveLike")
        cell.dateLabel.text = dateFormatter.string(from: Date())
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        cell.imageOfCell.image = image
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return .zero }
        let imageInsets = UIEdgeInsets(top: 4,
                                       left: 16,
                                       bottom: 4,
                                       right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / image.size.width
        let cellHeith = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeith
    }
}

