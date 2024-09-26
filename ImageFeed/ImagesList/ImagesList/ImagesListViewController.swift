//
//  ViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 04.07.2024.
//

import UIKit

protocol ImagesListViewControllerProtocol: UIViewController {
    init (presenter: ImagesListPresenterProtocol)
    var presenter: ImagesListPresenterProtocol { get set }
    var tableView: UITableView { get set }
    
    func configure(_ presenter: ImagesListPresenterProtocol)
    func setIsliked(cellIndex: IndexPath, isLiked: Bool)
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showProgressHud()
    func hideProgressHud()
}

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    //MARK: - Init and Deinit
    
    init(presenter: ImagesListPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        UIProgressHUD.dismiss()
    }
    
    //MARK: - Properties
    
    var presenter: ImagesListPresenterProtocol
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        if #available(iOS 15.0, *) {
            tableView.isPrefetchingEnabled = false
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypBlack
        tableView.separatorStyle = .none
        return tableView
    } ()
    
    //MARK: - Methods of lifecircle

    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0)
        configure(presenter)
        presenter.viewDidLoad()
    }
    
    //MARK: - Methods
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        presenter.view = self
    }
    
    func setIsliked(cellIndex: IndexPath, isLiked: Bool) {
        guard let cell = tableView.cellForRow(at: cellIndex),
              let imagesListCell = cell as? ImagesListCell
        else { return }
        imagesListCell.setIsLiked(isLiked)
    }

    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
                }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func showProgressHud() {
        UIProgressHUD.show()
    }
    
    func hideProgressHud() {
        UIProgressHUD.dismiss()
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
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        let configuredCell = presenter.config(cell: imageListCell, forRowAt: indexPath)
        configuredCell.delegate = self
        return configuredCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        presenter.tableViewWillDisplayRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tableViewDidSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let insetX: CGFloat = 16
        let insetY: CGFloat = 4
        return presenter.heightForRow(
            at: indexPath,
            insets: CGSize(width: insetX, height: insetY),
            width: tableView.bounds.width)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.viewCellDidTapLike(indexPath: indexPath)
    }
}
