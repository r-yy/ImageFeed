//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: BaseViewController {
    enum SegueIdentifiers: String {
        case ShowAuthScreen, ShowMainScreen
    }

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Vector")
        return view
    }()

    private var oAuthService = OAuth2Service()
    private var profileService = ProfileService()
    private var profileImageService = ProfileImageService()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNextScreen()
    }
}

//MARK: Make View
extension SplashViewController {
    func addSubview() {
        self.view.addSubview(imageView)
    }

    func applyConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(
                equalTo: self.view.centerXAnchor
            ),
            imageView.centerYAnchor.constraint(
                equalTo: self.view.centerYAnchor
            )
        ])
    }
    func makeView() {
        addSubview()
        applyConstraints()
    }
}

//MARK: Choose next screen
extension SplashViewController {
    private func showNextScreen() {
        if let token = OAuth2TokenStorage.shared.token {
            fetchProfile(token: token)
            switchToTabBarController()
        } else {
            let viewController = AuthViewController()
            let navigationViewController = UINavigationController(rootViewController: viewController)

            viewController.delegate = self

            navigationViewController.modalPresentationStyle = .fullScreen
            navigationViewController.modalTransitionStyle = .crossDissolve

            self.present(navigationViewController, animated: true)
        }
    }
}

//MARK: Switch screen after authorization
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(
        _ vc: AuthViewController,
        didAuthenticateWithCode code: String
    ) {
        UIBlocingProgressHUD.show()
        oAuthService.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                DispatchQueue.main.async {
                    self.showErrorAlert()
                    UIBlocingProgressHUD.dismiss()
                }
                break
            }
        }
    }

    func showErrorAlert() {
        guard let keyWindow = getKeyWindow(),
                  let topViewController = keyWindow.rootViewController?.topMostViewController() else {
                return
            }

        let alert = UIAlertController(
            title: "Ой",
            message: "Что то пошло не так",
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "ОК", style: .default) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(action)
        topViewController.present(alert, animated: false)
    }

    private func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
    }
}

extension SplashViewController {
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) {
            result in
            switch result {
            case .success(let profile):
                self.fetchImage(username: profile.username, token: token)
            case .failure:
                DispatchQueue.main.async {
                    self.showErrorAlert()
                    UIBlocingProgressHUD.dismiss()
                }
            }
        }
    }

    func fetchImage(username: String, token: String) {
        profileImageService.fetchProfileImage(username, token: token) {
            result in
            switch result {
            case .success:
                self.switchToTabBarController()
                UIBlocingProgressHUD.dismiss()
            case .failure:
                DispatchQueue.main.async {
                    self.showErrorAlert()
                    UIBlocingProgressHUD.dismiss()
                }
            }
        }
    }
}

//MARK: Create root ViewController
extension SplashViewController {
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Failed to invalid configuration")
            return
        }

        let tabBarController = TabBarController()

        if let profileVC = tabBarController.children.first(where: {
            $0 is ProfileViewController
        }) as? ProfileViewController {
            profileVC.profileService = self.profileService
            profileVC.profileImageService = self.profileImageService
        }

        window.rootViewController = tabBarController
    }
}
