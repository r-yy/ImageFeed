//
//  UITableViewDelegate.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 01.06.2023.
//

import UIKit

extension ImagesListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let viewController = SingleImageViewController()
        viewController.photo = presenter?.photos[indexPath.row]

        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve

        present(viewController, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return getCellHeight(at: indexPath.row)
    }
}
