//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 26.03.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static var reuseIdentifier = "ImagesListCell"

    let contentImage: UIImageView = {
        let imageView = UIImageView()

        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 16

        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypWhite
        label.font = UIFont(
            name: "SF Pro Text Regular",
            size: 13
        )

        return label
    }()

    private let likeButton: UIButton = {
        let button = UIButton()

        button.addTarget(nil, action: #selector(likeButtonTapped), for: .touchUpInside)

        return button
    }()
    
    private var subview: GradientBlurView?

    weak var delegate: ImagesListDelegate?

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        contentView.backgroundColor = .ypBlack
        contentView.clipsToBounds = true
        addSubviews()
        applyConstraints()
        addGradient()
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentImage.kf.cancelDownloadTask()
    }

    @objc
    private func likeButtonTapped() {
        delegate?.cellDidTapLike(cell: self)
    }

    func changeLikeState(isLiked: Bool) {
        let buttonImage = isLiked ? UIImage(
            named: LikeButtonNames.inactiveLike.rawValue
        ) : UIImage(
            named: LikeButtonNames.activeLike.rawValue
        )
        likeButton.setImage(buttonImage, for: .normal)
        likeButton.setTitle(String(), for: .normal)
    }
}

extension ImagesListCell {
    func addSubviews() {
        contentView.addSubview(contentImage)
        contentView.addSubview(dateLabel)
        contentView.bringSubviewToFront(dateLabel)
        contentView.addSubview(likeButton)

    }
}

extension ImagesListCell {
    func applyConstraints() {
        contentImage.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentImage.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 4
            ),
            contentImage.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            contentImage.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -4
            ),
            contentImage.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            dateLabel.bottomAnchor.constraint(
                equalTo: contentImage.bottomAnchor,
                constant: -8
            ),
            dateLabel.leadingAnchor.constraint(
                equalTo: contentImage.leadingAnchor,
                constant: 8
            ),
            likeButton.topAnchor.constraint(
                equalTo: contentImage.topAnchor
            ),
            likeButton.trailingAnchor.constraint(
                equalTo: contentImage.trailingAnchor
            ),
            likeButton.widthAnchor.constraint(
                equalToConstant: 42
            ),
            likeButton.heightAnchor.constraint(
                equalToConstant: 42
            )
        ])
    }
}

//MARK: Configure cell
extension ImagesListCell {
    enum LikeButtonNames: String {
        case activeLike
        case inactiveLike
    }
    
    func configCell(date: String, isLiked: Bool) {
        
        dateLabel.text = date

        let buttonImage = isLiked ? UIImage(
            named: LikeButtonNames.activeLike.rawValue
        ) : UIImage(
            named: LikeButtonNames.inactiveLike.rawValue
        )
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
        overlayView.layer.maskedCorners = [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner]
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(overlayView)
                
        NSLayoutConstraint.activate([
            overlayView.heightAnchor.constraint(
                equalToConstant: 30
            ),
            overlayView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            overlayView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            overlayView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -4
            )
        ])
    }
}
