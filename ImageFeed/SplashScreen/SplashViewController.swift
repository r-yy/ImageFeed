//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: BaseViewController {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Vector")
        return view
    }()

    private let oAuthService = OAuth2Service()
    private let profileService = ProfileService()
    private let profileImageService = ProfileImageService()
    private let tokenStorage = OAuth2TokenStorage.shared
    private let alertPresenter = AlertPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        tokenStorage.manageKeyChain()
        makeView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNextScreen()
    }
}

//MARK: Make View
extension SplashViewController {
    private func addSubview() {
        self.view.addSubview(imageView)
    }

    private func applyConstraints() {
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
    private func makeView() {
        addSubview()
        applyConstraints()
    }
}

//MARK: Choose next screen
extension SplashViewController {
    private func showNextScreen() {
        if let token = tokenStorage.keyChainToken {
            fetchProfile(token: token)
        } else {
            let authVC = AuthViewController()
            let navController = UINavigationController(
                rootViewController: authVC
            )
            authVC.delegate = self

            navController.modalPresentationStyle = .fullScreen
            navController.modalTransitionStyle = .crossDissolve

            self.present(navController, animated: true)
        }
    }
}

//MARK: Switch screen after authorisation
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(
        _ vc: AuthViewController,
        didAuthenticateWithCode code: String
    ) {
        UIBlockingProgressHUD.show()
        oAuthService.fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert()
            }
        }
    }
}

//MARK: Error Alert
extension SplashViewController {
    private func showErrorAlert() {
        guard let keyWindow = getKeyWindow(),
                  let topViewController = keyWindow
            .rootViewController?.topMostViewController()
        else { return }

        alertPresenter.showErrorAlert(viewController: topViewController)
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

//MARK: Fetch profile information
extension SplashViewController {
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.fetchImage(username: profile.username, token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert()
            }
        }
    }

    func fetchImage(username: String, token: String) {
        profileImageService.fetchProfileImage(username, token: token) {
            [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert()
            }
        }
    }
}

//MARK: Create root ViewController and inject profile info
extension SplashViewController {
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Failed to invalid configuration")
            return
        }
        let imagesListService = ImagesListService()
        let tabBarController = TabBarController(
            profileService: profileService,
            profileImageService: profileImageService,
            imagesListService: imagesListService
        )

        window.rootViewController = tabBarController
    }
}
