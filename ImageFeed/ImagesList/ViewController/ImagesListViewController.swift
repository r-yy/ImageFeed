//
//  ViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 17.03.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: BaseViewController {
    lazy var imagesListView: ImagesListView = {
        let view = ImagesListView()

        view.tableView.dataSource = self
        view.tableView.delegate = self

        return view
    }()

    var alertPresenter = AlertPresenter()
    var presenter: ImagesListPresenterProtocol?

    override func loadView() {
        super.loadView()
        view = imagesListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchImagesList()
    }
}

extension ImagesListViewController: ImagesListViewControllerProtocol {
    func insertRows(at rows: [Int]) {
        imagesListView.tableView.performBatchUpdates {
            let indexPaths = rows.map { i in
                IndexPath(row: i, section: 0)
            }
            imagesListView.tableView.insertRows(
                at: indexPaths, with: .automatic
            )
        }
    }

    func showErrorAlert() {
        alertPresenter.showErrorAlert(viewController: self)
    }

    func setCell(
        cell: ImagesListCell, imageURL: URL, date: String?, isLiked: Bool
    ) {
        let placeholder = ImagesPlaceholder()
        cell.presenter = presenter

        cell.contentImage.kf.setImage(
            with: imageURL, placeholder: placeholder
        ) {
            result in
            switch result {
            case .success:
                cell.configCell(
                    date: date ?? String(), isLiked: isLiked
                )
            default:
                cell.contentImage.image = UIImage(named: "stub")
            }
        }
    }
}
