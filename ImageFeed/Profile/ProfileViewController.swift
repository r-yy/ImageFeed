//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.04.2023.
//

import UIKit

final class ProfileViewController: BaseViewController {
    @IBOutlet weak var userpick: UIImageView!
    @IBOutlet weak var name: UILabel! {
        didSet {
            name.text = "Екатерина Новикова"
        }
    }
    @IBOutlet weak var username: UILabel! {
        didSet {
            username.text = "@ekaterina_nov"
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
