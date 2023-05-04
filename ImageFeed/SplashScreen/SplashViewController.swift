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
            performSegue(
                withIdentifier: SegueIdentifiers.ShowAuthScreen.rawValue,
                sender: nil
            )
        }
    }
}

//MARK: Delegate declaration
extension SplashViewController {
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == SegueIdentifiers
            .ShowAuthScreen.rawValue {

            guard let navigationController = segue
                .destination as? UINavigationController,

                  let viewController = navigationController
                .viewControllers[0] as? AuthViewController else {

                assertionFailure("Failed to prepare to ShowAuthScreen")
                return
            }
            viewController.delegate = self
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
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self.fetchProfile(token: token)
                case .failure:
                    //TODO: Make alert
                    UIBlocingProgressHUD.dismiss()
                    break
                }
            }
        }
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
                //Make alert
                UIBlocingProgressHUD.dismiss()
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
                //make alert
                UIBlocingProgressHUD.dismiss()
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

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        if let profileVC = tabBarController.children.first(where: {
            $0 is ProfileViewController
        }) as? ProfileViewController {
            profileVC.profileService = self.profileService
            profileVC.profileImageService = self.profileImageService
        }

        window.rootViewController = tabBarController
    }
}
