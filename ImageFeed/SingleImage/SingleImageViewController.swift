//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.04.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = image
        }
    }
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 1.25
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rescaleAndCenterImageInScrollView(image: imageView.image)
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let xOffset = (scrollView.visibleSize.width - imageView.frame.width) / 2
        let yOffset = (scrollView.visibleSize.height - imageView.frame.height) / 2
        scrollView.contentInset = UIEdgeInsets(top: yOffset, left: xOffset, bottom: yOffset, right: xOffset)
    }
}

extension SingleImageViewController {
    private func rescaleAndCenterImageInScrollView(image: UIImage?) {
        guard let image else { return }
        
        view.layoutIfNeeded()
        let yScale = scrollView.bounds.size.width / image.size.width
        let xScale = scrollView.bounds.size.height / image.size.height
        let maxScale = max(xScale, yScale)
        let scale = min(scrollView.maximumZoomScale, max(scrollView.minimumZoomScale, maxScale))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()

        let yPoint = (scrollView.contentSize.width - scrollView.bounds.size.width) / 2
        let xPoint = (scrollView.contentSize.height - scrollView.bounds.size.height) / 2
        scrollView.setContentOffset(CGPoint(x: yPoint, y: xPoint), animated: false)
    }
}
