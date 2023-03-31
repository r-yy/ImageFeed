//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 26.03.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static var reuseIdentifer = "ImagesListCell"
    
    private var subview: GradientBlurView?
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
}

//MARK: Configurate cell
extension ImagesListCell {
    enum LikeButtonNames: String {
        case activeLike
        case inactiveLike
    }
    
    func configCell(image: UIImage?, date: String, isLiked: Bool) {
        contentImage.image = image
        contentImage.bringSubviewToFront(dateLabel)
        
        dateLabel.text = date

        let buttonImage = isLiked ? UIImage(named: LikeButtonNames.inactiveLike.rawValue) : UIImage(named: LikeButtonNames.activeLike.rawValue)
        likeButton.setImage(buttonImage, for: .normal)
        likeButton.setTitle(String(), for: .normal)
    }
}

//MARK: Add gradient on cell
extension ImagesListCell {
    func addGradient() {
        subview = GradientBlurView()
        
        guard let overlayView = subview else {
            return
        }
        
        overlayView.layer.masksToBounds = true
        overlayView.layer.cornerRadius = 16
        overlayView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(overlayView)
                
        NSLayoutConstraint.activate([
            overlayView.heightAnchor.constraint(equalToConstant: 30),
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}

//MARK: Delete gradient for reused cells
extension ImagesListCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        subview?.removeFromSuperview()
    }
}
