//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 31.05.2023.
//

import Foundation

protocol AuthHelperProtocol: AnyObject {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}
