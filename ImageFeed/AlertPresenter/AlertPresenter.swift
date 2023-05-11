//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 11.05.2023.
//

import UIKit

final class AlertPresenter {
    func showErrorAlert(vc: UIViewController) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "ОК", style: .default) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(action)
        vc.present(alert, animated: false)
    }
}
