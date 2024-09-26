//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Денис Максимов on 20.09.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let presenter = ImagesListPresenterSpy(
            imagesListService: ImagesListService.shared,
            alertPresenter: AlertService.shared)
        let viewController = ImagesListViewController(presenter: presenter)
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) 
    }

    func testViewControllerDidConfigurePresenter() {
        //given
        let presenter = ImagesListPresenterSpy(
            imagesListService: ImagesListServiceStub(),
            alertPresenter: AlertService.shared)
        let viewController = ImagesListViewController(presenter: presenter)
        
        //when
        viewController.configure(presenter)
        
        //then
        XCTAssertNotNil(presenter.view)
    }
    
    func testViewControllerUpdateTableViewDidCalled() {
        //given
        let imagesListServiceStub = ImagesListServiceStub()
        let presenter = ImagesListPresenter(
            imagesListService: imagesListServiceStub,
            alertPresenter: AlertService.shared)
        let viewController = ImagesListViewControllerSpy(presenter: presenter)
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testViewControllerSetIsLikedDidCalled() {
        //given
        let imagesListServiceStub = ImagesListServiceStub()
        let presenter = ImagesListPresenter(
            imagesListService: imagesListServiceStub,
            alertPresenter: AlertService.shared)
        let viewController = ImagesListViewControllerSpy(presenter: presenter)
        
        //when
        _ = viewController.view
        let oldIsLiked = presenter.photos[5].isLiked
        presenter.viewCellDidTapLike(indexPath: IndexPath(row: 5, section: 0))
        
        //then
        XCTAssertTrue(viewController.setIsLikedCalled)
        XCTAssertNotEqual(oldIsLiked, presenter.photos[5].isLiked)
    }
    
    func testPresenterFetchFirstPage() {
        //given
        let presenter = ImagesListPresenter(
            imagesListService: ImagesListServiceStub(),
            alertPresenter: AlertService.shared)
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertEqual(presenter.photos.count, 10)
    }
    
    func testPresenterChangeLike() {
        //given
        let imagesListServiceStub = ImagesListServiceStub()
        let presenter = ImagesListPresenter(
            imagesListService: imagesListServiceStub,
            alertPresenter: AlertService.shared)
        
        //when
        presenter.viewDidLoad()
        let wasIsLiked = presenter.photos[5].isLiked
        presenter.viewCellDidTapLike(indexPath: IndexPath(row: 5, section: 0))
        
        //then
        XCTAssertNotEqual(wasIsLiked, presenter.photos[5].isLiked)
    }
    
    func testPresenterFetchNewPage() {
        //given
        let imagesListServiceStub = ImagesListServiceStub()
        let presenter = ImagesListPresenter(
            imagesListService: imagesListServiceStub,
            alertPresenter: AlertService.shared)
        
        //when
        presenter.viewDidLoad()
        presenter.tableViewWillDisplayRow(at: IndexPath(row: 9, section: 0))
        
        //then
        XCTAssertTrue(imagesListServiceStub.fetchPhotosNextPageCalled)
    }
}
