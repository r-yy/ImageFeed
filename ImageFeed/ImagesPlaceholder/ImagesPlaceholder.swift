//
//  StubsAnimation.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.05.2023.
//

import UIKit
import Kingfisher

final class ImagesPlaceholder: UIView {
    let gradient = CAGradientLayer()
    let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
    var animationLayers = Set<CALayer>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addGradient()
        addAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        gradient.frame = bounds
    }

    private func addGradient() {
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 16
        gradient.masksToBounds = true
        animationLayers.insert(gradient)
        layer.addSublayer(gradient)
    }

    private func addAnimation() {
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
}

extension ImagesPlaceholder: Placeholder {

}
