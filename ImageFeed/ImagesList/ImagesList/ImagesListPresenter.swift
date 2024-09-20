//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Денис Максимов on 18.09.2024.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    
    func viewDidLoad()
    func fetchPhotoNextPage()
    func config(cell: ImagesListCell, forRowAt indexPath: IndexPath) -> ImagesListCell
    func tableViewWillDisplayRow(at: IndexPath)
    func tableViewDidSelectRow(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath, width: CGFloat) -> CGFloat
    func viewCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    //MARK: - Init
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared,
         alertPresenter: AlertServiceProtocol = AlertService.shared
    ) {
        self.imagesListService = imagesListService
        self.alertPresenter = alertPresenter
    }
    
    //MARK: - Properties
    
    weak var view: ImagesListViewControllerProtocol?
    
    private(set) var photos: [Photo] = []
    
    private let imagesListService: ImagesListServiceProtocol
    
    private let alertPresenter: AlertServiceProtocol

    private var imagesListObserver: NSObjectProtocol?
    
    //MARK: - Methods
    
    func viewDidLoad() {
        imagesListObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }
                updateTableViewAnimated()
            }
        fetchPhotoNextPage()
    }
    
    func fetchPhotoNextPage() {
        imagesListService.fetchPhotosNextPage() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                break
            case .failure(_):
                alertPresenter.showNetworkAlertWithRetry(on: view) {
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
            view?.tableView.performBatchUpdates {
                let indexPaths = (oldPhotosCount..<newPhotosCount).map { i in
                    IndexPath(row: i, section: 0)
                    }
                view?.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}

//MARK: - Extensions

extension ImagesListPresenter {
    
    func config(cell: ImagesListCell, forRowAt indexPath: IndexPath) -> ImagesListCell {
        cell.configCell(with: photos[indexPath.row]) { [view] result in
            switch result {
            case .success():
                view?.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(_):
                break
            }
        }
        return cell
    }
    
    func tableViewWillDisplayRow(at indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            fetchPhotoNextPage()
        }
    }
    
    func tableViewDidSelectRow(at indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController(photo: photos[indexPath.row])
        singleImageViewController.modalPresentationStyle = .fullScreen
        singleImageViewController.modalTransitionStyle = .crossDissolve
        view?.present(singleImageViewController, animated: true)
    }
    
    func heightForRow(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        let image = photos[indexPath.row]
        let imageViewWidth = width - 32
        let scale = imageViewWidth / image.size.width
        let cellHeith = image.size.height * scale + 8
        return cellHeith
    }
    
    func viewCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
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
                    alertPresenter.showNetworkAlert(on: view, nil)
                }
            }
    }
}
