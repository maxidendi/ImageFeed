//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Денис Максимов on 18.09.2024.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    init(imagesListService: ImagesListServiceProtocol,
         alertPresenter: AlertServiceProtocol)
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    
    func viewDidLoad()
    func fetchPhotoNextPage()
    func config(cell: ImagesListCell, forRowAt indexPath: IndexPath) -> ImagesListCell
    func tableViewWillDisplayRow(at: IndexPath)
    func tableViewDidSelectRow(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath, insets: CGSize, width: CGFloat) -> CGFloat
    func viewCellDidTapLike(indexPath: IndexPath)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    //MARK: - Init
    
    init(imagesListService: ImagesListServiceProtocol,
         alertPresenter: AlertServiceProtocol
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
            view?.updateTableViewAnimated(oldCount: oldPhotosCount, newCount: newPhotosCount)
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
    
    func heightForRow(at indexPath: IndexPath, insets: CGSize, width: CGFloat) -> CGFloat {
        let image = photos[indexPath.row]
        let imageViewWidth = width - insets.width * 2
        let scale = imageViewWidth / image.size.width
        let cellHeith = image.size.height * scale + insets.height * 2
        return cellHeith
    }
    
    func viewCellDidTapLike(indexPath: IndexPath) {
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(
            index: indexPath.row,
            isLike: !photos[indexPath.row].isLiked) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self else { return }
                switch result {
                case .success():
                    photos = imagesListService.photosProvider
                    view?.setIsliked(cellIndex: indexPath, isLiked: photos[indexPath.row].isLiked)
                case .failure(_):
                    alertPresenter.showNetworkAlert(on: view, nil)
                }
            }
    }
}
