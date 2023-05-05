//
//  UIColor + Extensions.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 27.03.2023.
//

import UIKit

extension UIColor {
    static var ypBlack: UIColor { UIColor(named: "black") ?? UIColor.black }
    static var ypWhite: UIColor { UIColor(named: "white") ?? UIColor.white }
    static var ypGray: UIColor { UIColor(named: "gray") ?? UIColor.gray }
}

extension URLSession {
    private enum FetchError: Error {
        case codeError
    }

    func objectTask<T: Decodable>(
        for request: URLRequest,
        completition: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request) {
            data, response, error in
            DispatchQueue.global(qos: .utility).async {
                if
                    let error {
                    completition(.failure(error))
                }

                if
                    let response = response as? HTTPURLResponse,
                    response.statusCode < 200 || response.statusCode > 299 {
                    completition(.failure(FetchError.codeError))
                }

                guard let data else {
                    assertionFailure("Data is empty")
                    return
                }

                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completition(.success(result))
                    }
                }
                catch let error {
                    assertionFailure("Decoding error: \(error)")
                    completition(.failure(FetchError.codeError))
                }
            }
        }
        return task
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }

        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topMostViewController() ?? self
        }

        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topMostViewController() ?? self
        }

        return self
    }
}
