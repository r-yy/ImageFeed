//
//  BaseViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 09.04.2023.
//

import UIKit

class BaseViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override var view: UIView! {
        didSet {
            view.backgroundColor = .ypBlack
        }
    }
}
