//
//  CircularImageView.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 11.04.2023.
//

import UIKit

final class CircularImageView: UIImageView {
    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.height / 2
        }
    }
}
