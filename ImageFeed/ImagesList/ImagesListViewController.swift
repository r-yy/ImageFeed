//
//  ViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 17.03.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: BaseViewController {
    var photos: [Photo] = []

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

    private var imagesListService = ImagesListService()


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        imagesListService.delegate = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500

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
//        let image = UIImage(named: photosName[indexPath.row])
//        viewController.image = image

        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve

        present(viewController, animated: true)
    }
    
//    func tableView(
//        _ tableView: UITableView,
//        heightForRowAt indexPath: IndexPath
//    ) -> CGFloat {
//        if didImagesFetched[indexPath.row] != false {
//            let photo = photos[indexPath.row]
//            let scale = tableView.bounds.size.width / photo.size.width
//            return ceil(photo.size.height * scale)
//        } else {
//            return 200
//        }
//    }
}

//MARK: TableView data source
extension ImagesListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return photos.count
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
        let imageURL = photos[indexPath.row].thumbImageURL
        guard let url = URL(string: imageURL) else { return UITableViewCell() }
        imageListCell.contentImage.kf.setImage(with: url, placeholder: UIImage(named: "stub"))
        let date = dateFormatter.string(from: Date())
        let isLiked = indexPath.row % 2 == 0

        imageListCell.configCell(
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
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchImagesList()
        }
    }
}

extension ImagesListViewController: ImagesListDelegate {
    func addData() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos

        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}
