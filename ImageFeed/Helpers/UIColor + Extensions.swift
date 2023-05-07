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
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let globalQueue = DispatchQueue.global(qos: .utility)
        let mainQueue = DispatchQueue.main

        let task = dataTask(with: request) {
            data, response, error in
            globalQueue.async {
                if let error {
                    mainQueue.async {
                        completion(.failure(error))
                    }
                }

                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode > 299 {
                    mainQueue.async {
                        completion(.failure(FetchError.codeError))
                    }
                }

                guard let data else {
                    assertionFailure("Data is empty")
                    return
                }

                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    mainQueue.async {
                        completion(.success(result))
                    }
                }
                catch let error {
                    assertionFailure("Decoding error: \(error)")
                    mainQueue.async {
                        completion(.failure(FetchError.codeError))
                    }
                }
            }
        }
        return task
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presentedVC = self.presentedViewController {
            return presentedVC.topMostViewController()
        }

        if let navController = self as? UINavigationController {
            return navController.visibleViewController?.topMostViewController() ?? self
        }

        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topMostViewController() ?? self
        }

        return self
    }
}
