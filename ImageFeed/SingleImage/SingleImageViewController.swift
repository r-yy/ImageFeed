//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.04.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: BaseViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.minimumZoomScale = 0.01
        scrollView.maximumZoomScale = 1.25

        return scrollView
    }()

    private let imageView = UIImageView()

    private lazy var backButton: UIButton = {
        let button = UIButton()

        button.setImage(
            UIImage(named: "lightBack"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton()

        button.setImage(
            UIImage(named: "share"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(shareButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    var photo: Photo? {
        didSet {
            if let photo = photo,
               let url = URL(string: photo.largeImageURL) {

                ProgressHUD.animationType = .singleCirclePulse
                ProgressHUD.colorProgress = .ypWhite
                ProgressHUD.show()
                imageView.kf.setImage(with: url) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let image):
                        let size = image.image.size
                        self.rescaleAndCenterImageInScrollView(
                            imageSize: size
                        )
                        ProgressHUD.dismiss()
                    case .failure:
                        assertionFailure()
                        ProgressHUD.dismiss()
                    }

                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        addSubviews()
        applyConstraints()
    }

    @objc
    private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func shareButtonTapped() {
        presentActivityViewController()
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(
        in scrollView: UIScrollView
    ) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(
        _ scrollView: UIScrollView
    ) {
        let xOffset =
        (scrollView.contentSize.width - imageView.frame.width) / 2
        let yOffset =
        (scrollView.contentSize.height - imageView.frame.height) / 2
        scrollView.contentInset = UIEdgeInsets(
            top: yOffset,
            left: xOffset,
            bottom: yOffset,
            right: xOffset
        )
    }
}

extension SingleImageViewController {
    private func rescaleAndCenterImageInScrollView(
        imageSize: CGSize?
    ) {
        guard let imageSize = imageSize else { return }
        view.layoutIfNeeded()
        let yScale = scrollView.bounds.size.width / imageSize.width
        let xScale = scrollView.bounds.size.height / imageSize.height
        let scale = min(yScale, xScale)
        scrollView.setZoomScale(scale, animated: false)
        scrollView.minimumZoomScale = scale
        scrollView.layoutIfNeeded()

        let xPoint =
        (scrollView.contentSize.width - scrollView.bounds.size.width) / 2
        let yPoint =
        (scrollView.contentSize.height - scrollView.bounds.size.height) / 2
        scrollView.setContentOffset(
            CGPoint(x: xPoint, y: yPoint),
            animated: false)

    }
}

extension SingleImageViewController {
    private func presentActivityViewController() {
        guard let imageToShare = imageView.image else { return }
        let activityViewController = UIActivityViewController(
            activityItems: [imageToShare],
            applicationActivities: nil
        )
        present(activityViewController, animated: true)
    }
}

extension SingleImageViewController {
    private func addSubviews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        self.view.addSubview(backButton)
        self.view.addSubview(shareButton)
    }
}

extension SingleImageViewController {
    private func applyConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: self.view.topAnchor
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor
            ),
            imageView.topAnchor.constraint(
                equalTo: scrollView.topAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor
            ),
            imageView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor
            ),
            imageView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor
            ),
            backButton.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),
            backButton.leadingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                constant: 8
            ),
            backButton.widthAnchor.constraint(
                equalToConstant: 48
            ),
            backButton.heightAnchor.constraint(
                equalToConstant: 48
            ),
            shareButton.centerXAnchor.constraint(
                equalTo: self.view.centerXAnchor
            ),
            shareButton.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor,
                constant: -51
            ),
            shareButton.widthAnchor.constraint(
                equalToConstant: 50
            ),
            shareButton.heightAnchor.constraint(
                equalToConstant: 50
            )
        ])
    }
}
