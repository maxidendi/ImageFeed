//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Денис Максимов on 10.07.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
        
    //MARK: - Properties
    
    var image: UIImage = UIImage()
    private var imageView: UIImageView = UIImageView()
    private var scrollView: UIScrollView = UIScrollView()
    
    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        addScrollView()
        addImageView()
        addBackButton()
        addShareButton()
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    //MARK: - Methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.height / imageSize.height
        let wScale = visibleRectSize.width / imageSize.width
        let scale = min(maxZoomScale, max(hScale, wScale))
        scrollView.minimumZoomScale = min(maxZoomScale, max(minZoomScale, min(hScale, wScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func addScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func addImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        imageView.image = image
        imageView.frame.size = image.size
        scrollView.contentSize = imageView.bounds.size
    }
    
    private func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backward"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        backButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        backButton.addTarget(self, action: #selector(didTapbackButton), for: .touchUpInside)
    }
    
    @objc private func didTapbackButton() {
        dismiss(animated: true)
    }
    
    private func addShareButton() {
        let shareButton = UIButton(type: .custom)
        shareButton.setImage(UIImage(named: "share_button"), for: .normal)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shareButton)
        shareButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }
    
    @objc private func didTapShareButton() {
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
        var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let visibleRectSize = scrollView.bounds.size
        let newContentSize = scrollView.contentSize
        if visibleRectSize.width > newContentSize.width {
            insets.left = (visibleRectSize.width - newContentSize.width) / 2
            insets.right = (visibleRectSize.width - newContentSize.width) / 2
        }
        if visibleRectSize.height > newContentSize.height {
            insets.top = (visibleRectSize.height - newContentSize.height) / 2
            insets.bottom = (visibleRectSize.height - newContentSize.height) / 2
        }
        scrollView.contentInset = insets
    }
}

