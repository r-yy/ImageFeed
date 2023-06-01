//
//  UITableViewDataSource.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 01.06.2023.
//

import UIKit

extension ImagesListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let presenter else {
            alertPresenter.showErrorAlert(viewController: self)
            return 0
        }
        return presenter.photos.count
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

        presenter?.prepare(cell: imageListCell, at: indexPath.row)

        return imageListCell
    }

    //Upload next page
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        presenter?.shouldUploadNewPage(currentRow: indexPath.row)
    }
}
