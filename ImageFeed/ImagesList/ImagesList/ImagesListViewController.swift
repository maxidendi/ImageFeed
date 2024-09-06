//
//  ViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 04.07.2024.
//

import UIKit
import ProgressHUD

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController {
    
    //MARK: - Properties
    
    private var photos: [Photo] = []
    
    private let imagesListService = ImagesListService.shared
    
    private let alertPresenter = AlertService.shared
    
    private var imagesListObserver: NSObjectProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypBlack
        tableView.separatorStyle = .none
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        return tableView
    } ()
    
    //MARK: - Methods of lifecircle

    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0)
        imagesListObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }
                updateTableViewAnimated()
            }
        fetchPhotoNextPage()
    }
    
    //MARK: - Methods
    
    private func fetchPhotoNextPage() {
        ProgressHUD.animate()
        imagesListService.fetchPhotosNextPage() { [weak self] result in
            ProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success():
                break
            case .failure(_):
                alertPresenter.showNetworkAlertWithRetry(on: self) {
                    self.fetchPhotoNextPage()
                }
            }
        }
    }
    
    private func updateTableViewAnimated() {
        let oldPhotosCount = photos.count
        let newPhotosCount = imagesListService.photosProvider.count
        photos = imagesListService.photosProvider
        if oldPhotosCount != newPhotosCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldPhotosCount..<newPhotosCount).map { i in
                    IndexPath(row: i, section: 0)
                    }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }

    private func addTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - Extensions

extension ImagesListViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        imageListCell.delegate = self
        imageListCell.configCell(with: photos[indexPath.row]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(_):
                break
            }
        }
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            fetchPhotoNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController(photo: photos[indexPath.row])
        singleImageViewController.modalPresentationStyle = .fullScreen
        singleImageViewController.modalTransitionStyle = .crossDissolve
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
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

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(
            index: indexPath.row,
            isLike: !photo.isLiked) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self else { return }
                switch result {
                case .success():
                    photos = imagesListService.photosProvider
                    cell.setIsLiked(photos[indexPath.row].isLiked)
                case .failure(_):
                    alertPresenter.showNetworkAlert(on: self)
                }
            }
    }
}
