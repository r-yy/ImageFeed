//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 25.04.2023.
//

import UIKit

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
    private var oAuthToken = OAuth2TokenStorage()

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
        if let _ = oAuthToken.token {
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

                fatalError("Failed to prepare to ShowAuthScreen")
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
        oAuthService.fetchAuthToken(code: code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.switchToTabBarController()
                case .failure:
                    //TODO: Make alert
                    break
                }
            }
        }
    }
}

//MARK: Create root ViewController
extension SplashViewController {
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Fatal Error: Invalid configuration")
        }

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarController
    }
}
