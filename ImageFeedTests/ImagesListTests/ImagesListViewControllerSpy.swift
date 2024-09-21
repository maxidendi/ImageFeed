//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Денис Максимов on 20.09.2024.
//

@testable import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
    
    init(presenter: ImagesListPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var setIsLikedCalled: Bool = false
    var updateTableViewAnimatedCalled: Bool = false
    var presenter: ImagesListPresenterProtocol
    var tableView: UITableView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(presenter)
        presenter.viewDidLoad()
    }
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        presenter.view = self
    }
    
    func setIsliked(cellIndex: IndexPath, isLiked: Bool) {
        setIsLikedCalled = true
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
    }
}
