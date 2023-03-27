//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 26.03.2023.
//

import UIKit

class ImagesListCell: UITableViewCell {
    
    static var reuseIdentifer = "ImagesListCell"
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
}
