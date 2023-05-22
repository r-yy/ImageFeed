//
//  ViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 17.03.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: BaseViewController {
    private let photosName: [String] = Array(0..<20).map{"\($0)"}

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateFormat = "dd MMMM yyyy"

        return formatter
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()

        tableView.contentInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0
        )
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .ypBlack
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )

        return tableView
    }()

    private let imagesListService = ImagesListService()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        imagesListService.delegate = self

        makeView()
        imagesListService.fetchImagesList()
    }
}

//MARK: TableView delegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let viewController = SingleImageViewController()
        let image = UIImage(named: photosName[indexPath.row])
        viewController.image = image

        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve

        present(viewController, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let photo = imagesListService.photos[indexPath.row]
        let scale = tableView.bounds.size.width / photo.size.width

        return ceil(photo.size.height * scale)

    }
}

//MARK: TableView data source
extension ImagesListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        imagesListService.photos.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        let contentImage = UIImage()

        let date = dateFormatter.string(from: Date())
        let isLiked = indexPath.row % 2 == 0

        imageListCell.configCell(
            image: contentImage,
            date: date,
            isLiked: isLiked
        )

        return imageListCell
    }
}

//MARK: Make View
extension ImagesListViewController {
    private func addSubviews() {
        self.view.addSubview(tableView)
    }

    private func applyConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: self.view.topAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor
            )
        ])
    }

    private func makeView() {
        addSubviews()
        applyConstraints()
    }
}

extension ImagesListViewController {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard let cell = cell as? ImagesListCell else { return }

        if indexPath.row >= imagesListService.photos.count - 1 {
            imagesListService.fetchImagesList()
        } else {
            let photo = imagesListService.photos[indexPath.row]
            let url = URL(string: photo.thumbImageURL)
            cell.contentImage.kf.setImage(with: url)
        }
    }
}

extension ImagesListViewController: ImagesListDelegate {
    func addData() {
        tableView.reloadData()
    }
}
