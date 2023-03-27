//
//  GradientView.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 27.03.2023.
//

import UIKit

class GradientBlurView: UIView {

    private let blurEffectView = UIVisualEffectView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientBlur()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientBlur()
    }

    private func setupGradientBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.ypBlack.withAlphaComponent(0.2).cgColor,
            UIColor.ypBlack.withAlphaComponent(0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.locations = [0, 1]
        blurEffectView.layer.mask = gradientLayer
        addSubview(blurEffectView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.layer.mask?.frame = blurEffectView.bounds
    }
}
