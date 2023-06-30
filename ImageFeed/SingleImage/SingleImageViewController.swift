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
            UIImage(systemName: "xmark"),
            for: .normal
        )
        button.imageView?.tintColor = .ypGray
        button.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        button.accessibilityIdentifier = "BackButton"

        return button
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton()

        let image = UIImage(
            systemName: "arrowshape.turn.up.forward"
        )?.withTintColor(.ypGray)

        let imageData = image?.pngData()

        button.setImage(
            UIImage(data: imageData ?? Data(), scale: 2),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(shareButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var shareLabel: UILabel = {
        let label = UILabel()

        label.text = "share"
        label.font = UIFont(
            name: "SF Pro Text Bold", size: 12
        )
        label.textColor = .ypGray

        return label
    }()

    var photo: Photo? {
        didSet {
            if let photo = photo,
               let url = URL(string: photo.largeImageURL) {

                if !ImageCache.default.isCached(forKey: url.absoluteString) {
                    ProgressHUD.animationType = .singleCirclePulse
                    ProgressHUD.colorProgress = .ypWhite
                    ProgressHUD.show()
                }

                imageView.kf.setImage(with: url) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let image):
                        self.imageSize = image.image.size
                        self.rescaleAndCenterImageInScrollView(
                            imageSize: self.imageSize,
                            animated: false
                        )
                    case .failure:
                        self.imageView.image = UIImage(named: "stub")
                    }
                    ProgressHUD.dismiss()
                }
            }
        }
    }

    private var singleTap: UITapGestureRecognizer = {
        let singleTap = UITapGestureRecognizer()
        singleTap.numberOfTapsRequired = 1
        return singleTap
    }()

    private var doubleTap: UITapGestureRecognizer = {
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        return doubleTap
    }()

    private var imageSize: CGSize?
    private var startScale: CGFloat?
    private var isScrollViewDidZoomed = false

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        addSubviews()
        applyConstraints()

        singleTap.require(toFail: doubleTap)
        scrollView.addGestureRecognizer(singleTap)
        scrollView.addGestureRecognizer(doubleTap)
        doubleTap.addTarget(self, action: #selector(handleDoubleTap))
    }

    @objc
    private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
        ProgressHUD.dismiss()
    }

    @objc
    private func shareButtonTapped() {
        presentActivityViewController()
    }

    @objc
    private func handleDoubleTap() {
        if isScrollViewDidZoomed {
            rescaleAndCenterImageInScrollView(imageSize: imageSize, animated: true)
        } else {
            scrollView.setZoomScale(2, animated: true)
            scrollView.layoutIfNeeded()

            let xPoint =
            (scrollView.contentSize.width - scrollView.bounds.size.width) / 2
            let yPoint =
            (scrollView.contentSize.height - scrollView.bounds.size.height) / 2
            scrollView.setContentOffset(
                CGPoint(x: xPoint, y: yPoint),
                animated: false)
            isScrollViewDidZoomed = true
        }
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
        (scrollView.visibleSize.height - imageView.frame.height) / 2
        scrollView.contentInset = UIEdgeInsets(
            top: yOffset,
            left: xOffset,
            bottom: yOffset,
            right: xOffset
        )
        isScrollViewDidZoomed = true
    }
}

extension SingleImageViewController {
    private func rescaleAndCenterImageInScrollView(
        imageSize: CGSize?,
        animated: Bool
    ) {
        guard let imageSize = imageSize else { return }
        view.layoutIfNeeded()
        let yScale = scrollView.bounds.size.width / imageSize.width
        let xScale = scrollView.bounds.size.height / imageSize.height
        let scale = min(yScale, xScale)
        scrollView.setZoomScale(scale, animated: animated)
        scrollView.minimumZoomScale = scale
        startScale = scale
        scrollView.layoutIfNeeded()

        let xPoint =
        (scrollView.contentSize.width - scrollView.bounds.size.width) / 2
        let yPoint =
        (scrollView.contentSize.height - scrollView.bounds.size.height) / 2
        scrollView.setContentOffset(
            CGPoint(x: xPoint, y: yPoint),
            animated: false)
        isScrollViewDidZoomed = false
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
        self.view.addSubview(shareLabel)
        view.bringSubviewToFront(shareButton)
    }
}

extension SingleImageViewController {
    private func applyConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareLabel.translatesAutoresizingMaskIntoConstraints = false

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
            backButton.trailingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                constant: -8
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
            ),
            shareLabel.topAnchor.constraint(
                equalTo: shareButton.bottomAnchor,
                constant: -10
            ),
            shareLabel.centerXAnchor.constraint(
                equalTo: shareButton.centerXAnchor
            )
        ])
    }
}
