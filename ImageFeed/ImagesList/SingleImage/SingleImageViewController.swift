//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 10.07.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {
    
    //MARK: - Init
    
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    //MARK: - Properties
    
    private var photo: Photo
    
    private let alertPresenter = AlertService.shared
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentSize = imageView.bounds.size
        return scrollView
    } ()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backward"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.accessibilityIdentifier = "navBackButton"
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return backButton
    } ()
    
    private lazy var shareButton: UIButton = {
        let shareButton = UIButton(type: .custom)
        shareButton.setImage(UIImage(named: "share_button"), for: .normal)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return shareButton
    } ()
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.01
        scrollView.maximumZoomScale = 1.25
        addScrollViewWithImageView()
        addBackButton()
        addShareButton()
        setImage()
    }
    
    //MARK: - Methods
    
    private func setImage() {
        ProgressHUD.animate()
        imageView.kf.setImage(
            with: photo.largeImageURL) { [weak self] result in
                ProgressHUD.dismiss()
                guard let self else { return }
                switch result {
                case .success(let value):
                    rescaleAndCenterImageInScrollView(image: value.image)
                case .failure(_):
                    if !isBeingDismissed {
                        alertPresenter.showNetworkAlertWithRetry(on: self) {
                            self.setImage()
                        }
                    }
                }
            }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        imageView.bounds.size = image.size
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.height / imageSize.height
        let wScale = visibleRectSize.width / imageSize.width
        let scale = min(maxZoomScale, max(hScale, wScale))
        scrollView.minimumZoomScale = min(maxZoomScale, max(minZoomScale, min(hScale, wScale)))
        scrollView.maximumZoomScale = 3 * scale
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func addScrollViewWithImageView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func addBackButton() {
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    @objc private func didTapBackButton() {
        ProgressHUD.dismiss()
        dismiss(animated: true)
        imageView.kf.cancelDownloadTask()
    }
    
    private func addShareButton() {
        view.addSubview(shareButton)
        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    @objc private func didTapShareButton() {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
}

//MARK: - Extensions

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            imageView
        }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let xInset = max((scrollView.bounds.width - scrollView.contentSize.width) / 2, 0)
        let yInset = max((scrollView.bounds.height - scrollView.contentSize.height) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
    }
}

