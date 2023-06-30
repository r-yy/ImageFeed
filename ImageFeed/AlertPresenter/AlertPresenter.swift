//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 11.05.2023.
//

import UIKit

final class AlertPresenter {
    func showErrorAlert(viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "ОК", style: .default) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(action)
        viewController.present(alert, animated: false)
    }

    func showExitAlert(viewController: UIViewController, delegate: ProfilePresenterProtocol) {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        let exitAction = UIAlertAction(title: "Да", style: .default) {_ in
            delegate.exit()
        }
        let dismissAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)

        alert.addAction(exitAction)
        alert.addAction(dismissAction)
        viewController.present(alert, animated: true)
    }
}
