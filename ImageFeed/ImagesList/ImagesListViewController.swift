//
//  ViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 17.03.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

final class ImagesListViewController: BaseViewController, AlertPresenterReloadDelegate {
    var photos: [Photo] = []

    private lazy var dateFormatterToPresent: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateFormat = "dd MMMM yyyy"

        return formatter
    }()
    private let isoDateFormatter = ISO8601DateFormatter()

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
    private var alertPresenter = AlertPresenter()

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
        viewController.photo = photos[indexPath.row]

        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve

        present(viewController, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let photo = photos[indexPath.row]
        let scale = tableView.bounds.size.width / photo.size.width * 0.9
        return ceil(photo.size.height * scale)
    }
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
        imageListCell.delegate = self

        var cellDate = String()
        if let stringDate = photos[indexPath.row].createdAt,
           let date = isoDateFormatter.date(from: stringDate) {
            cellDate = dateFormatterToPresent.string(from: date)
        }

        let isLiked = photos[indexPath.row].isLiked
        let imageURL = photos[indexPath.row].smallImageURL
        let stubsView = ImagesPlaceholder()
        
        guard let url = URL(string: imageURL) else {
            return UITableViewCell()
        }

        imageListCell.contentImage.kf.setImage(
            with: url, placeholder: stubsView
        ) {
            result in
            switch result {
            case .success:
                imageListCell.configCell(
                    date: cellDate, isLiked: isLiked
                )
            default:
                break
            }
            ProgressHUD.dismiss()
        }
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

//MARK: Upload next page
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

//MARK: ImagesList Delegate
extension ImagesListViewController: ImagesListDelegate {
    func addData() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        syncPhotos()

        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }

    func cellDidTapLike(
        cell: ImagesListCell,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let photo = photos[indexPath.row]

        imagesListService.changeLike(
            photoID: photo.id, isLiked: photo.isLiked
        ) {
            (result: Result<Void, Error>) in
            switch result {
            case .success:
                cell.changeLikeState(isLiked: photo.isLiked)
                completion(.success(!photo.isLiked))
            case .failure:
                self.alertPresenter.showErrorAlert(vc: self)
            }
        }
    }

    func syncPhotos() {
        photos = imagesListService.photos
    }

    func showServerErrorAlert() {
        alertPresenter.showServerErrorAlert(vc: self, delegate: self)
    }

    func reloadImages() {
        imagesListService.fetchImagesList()
    }
}
