//
//  ViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 17.03.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    // Предопределяем статус бар в темной теме
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return tableView.rowHeight
        }
        let multiplier = tableView.frame.width / image.size.width
        return image.size.height * multiplier
    }
}

extension ImagesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifer, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let contentImage = UIImage(named: photosName[indexPath.row])
        let date = dateFormatter.string(from: Date())
        let isLiked = indexPath.row % 2 == 0
        imageListCell.configCell(image: contentImage, date: date, isLiked: isLiked)
        
        addOverlay(for: imageListCell, with: indexPath)
        
        
        return imageListCell
    }
    
    func addOverlay(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let overlayView = GradientBlurView()
        overlayView.layer.masksToBounds = true
        overlayView.layer.cornerRadius = 16
        overlayView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.heightAnchor.constraint(equalToConstant: 30),
            overlayView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
        ])
        let bottomConstrait = NSLayoutConstraint(
            item: overlayView,
            attribute: NSLayoutConstraint.Attribute.bottom,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: cell.contentView,
            attribute: NSLayoutConstraint.Attribute.bottom,
            multiplier: 1,
            constant: -4
        )
        
        cell.contentView.addConstraint(bottomConstrait)
    }
}
