//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.04.2023.
//

import UIKit

final class ProfileViewController: BaseViewController {
    @IBOutlet weak var userpic: UIImageView! {
        didSet {
            userpic.layer.cornerRadius = userpic.frame.height / 2
        }
    }
    @IBOutlet weak var name: UILabel! {
        didSet {
            name.text = "Рамиль Янбердин"
        }
    }
    @IBOutlet weak var username: UILabel! {
        didSet {
            username.text = "@yanram"
        }
    }
    @IBOutlet weak var userDescription: UILabel! {
        didSet {
            userDescription.text = "Hello, world!"
        }
    }
    @IBOutlet weak var exitButton: UIButton! {
        didSet {
            exitButton.setTitle("", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func exit(_ sender: UIButton) {
        
    }
}
