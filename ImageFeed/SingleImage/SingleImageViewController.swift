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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.setTitle("", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
