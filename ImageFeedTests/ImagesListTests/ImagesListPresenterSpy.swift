//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Денис Максимов on 20.09.2024.
//

@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    init(imagesListService: ImagesListServiceProtocol,
         alertPresenter: AlertServiceProtocol) {
        self.imagesListService = imagesListService
    }
    
    var viewDidLoadCalled = false
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imagesListObserver: NSObjectProtocol?
    let imagesListService: ImagesListServiceProtocol
    
    func viewDidLoad() {
        imagesListObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }
                photos = imagesListService.photosProvider
            }
        fetchPhotoNextPage()
        viewDidLoadCalled = true
    }
    
    func fetchPhotoNextPage() {
        imagesListService.fetchPhotosNextPage({_ in})
    }
    
    func config(cell: ImagesListCell, forRowAt indexPath: IndexPath) -> ImagesListCell {
        return cell
    }
    
    func heightForRow(at indexPath: IndexPath, insets: CGSize, width: CGFloat) -> CGFloat {
        CGFloat()
    }
    
    func tableViewWillDisplayRow(at: IndexPath) {}
    func tableViewDidSelectRow(at indexPath: IndexPath) {}
    func viewCellDidTapLike(indexPath: IndexPath) {}
}
