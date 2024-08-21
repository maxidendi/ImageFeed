//
//  ViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 04.07.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    //MARK: - Properties
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map({"\($0)"})    
    private var imagesListCell: ImagesListCell?
    static let didChangeNotification = Notification.Name("ImagesListProviderDidChange")
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    private var tableView: UITableView?
    
    //MARK: - Methods of lifecircle

    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0)
    }
    
    //MARK: - Methods
        
    private func addTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.backgroundColor = .ypBlack
        tableView.separatorStyle = .none
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        self.tableView = tableView
    }
}

//MARK: - Extensions

extension ImagesListViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        let image = UIImage(named: photosName[indexPath.row]) ?? UIImage()
        imageListCell.configCell(dateFormatter: dateFormatter, with: indexPath, cellImage: image)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.isModalInPresentation = true
        singleImageViewController.modalPresentationStyle = .fullScreen
        singleImageViewController.modalTransitionStyle = .crossDissolve
        singleImageViewController.image = UIImage(named: photosName[indexPath.row]) ?? UIImage()
        present(singleImageViewController, animated: true)
    }
    
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

