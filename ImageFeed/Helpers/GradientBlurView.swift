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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.layer.mask?.frame = blurEffectView.bounds
    }

    private func setupGradientBlur() {
        let blurEffect = UIBlurEffect(style: .regular)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.6).cgColor,
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.03).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.locations = [0, 1]
        blurEffectView.layer.mask = gradientLayer
        addSubview(blurEffectView)
    }
}
