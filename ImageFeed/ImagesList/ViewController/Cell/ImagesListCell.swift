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

        button.addTarget(
            nil,
            action: #selector(likeButtonTapped),
            for: .touchUpInside
        )
        button.setTitle(String(), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 2.0
        button.clipsToBounds = false
        button.accessibilityIdentifier = "LikeButton"

        return button
    }()
    
    private var subview = GradientBlurView()

    var presenter: ImagesListPresenterProtocol?

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
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentImage.kf.cancelDownloadTask()
        subview.isHidden = true
        dateLabel.text = nil
        likeButton.setImage(nil, for: .normal)
    }

    @objc
    private func likeButtonTapped() {
        presenter?.cellDidTapLike(cell: self) {
            (result: Result<Bool, Error>) in
            switch result {
            case .success(let success):
                self.changeLikeState(isLiked: success)
            case .failure:
                self.presenter?.showErrorAlert()
            }
            self.likeButton.layer.removeAllAnimations()
        }
        animateButton()
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

        subview.isHidden = false
        addGradient()
    }
}

//MARK: Add gradient on cell
extension ImagesListCell {
    func addGradient() {
        subview.layer.masksToBounds = true
        subview.layer.cornerRadius = 16
        subview.layer.maskedCorners = [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner]
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(subview)
                
        NSLayoutConstraint.activate([
            subview.heightAnchor.constraint(
                equalToConstant: 30
            ),
            subview.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            subview.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            subview.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -4
            )
        ])
    }
}

//MARK: Change button image state
extension ImagesListCell {
    func changeLikeState(isLiked: Bool) {
        let buttonImage = isLiked ? UIImage(named: LikeButtonNames.activeLike.rawValue)
                                  : UIImage(named: LikeButtonNames.inactiveLike.rawValue)

        self.likeButton.setImage(buttonImage, for: .normal)
    }

    private func animateButton() {
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [.repeat]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.likeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.likeButton.transform = .identity
            }
        }
    }
}
