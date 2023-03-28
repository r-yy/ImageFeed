//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 26.03.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static var reuseIdentifer = "ImagesListCell"
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
}

extension ImagesListCell {
    enum LikeButtonNames: String {
        case activeLike
        case inactiveLike
    }
    
    func configCell(image: UIImage?, date: String, isLiked: Bool) {
        contentImage.image = image
        
        dateLabel.text = date
        dateLabel.textColor = UIColor.ypWhite
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        
        let buttonImage = isLiked ? UIImage(named: LikeButtonNames.inactiveLike.rawValue) : UIImage(named: LikeButtonNames.activeLike.rawValue)
        likeButton.setImage(buttonImage, for: .normal)
        likeButton.setTitle(String(), for: .normal)
    }
    
}
