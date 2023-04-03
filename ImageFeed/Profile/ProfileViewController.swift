//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.04.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBOutlet weak var userpick: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = "Екатерина Новикова"
        username.text = "@ekaterina_nov"
        userDescription.text = "Hello, world!"
        exitButton.setTitle("", for: .normal)
    }
    
    @IBAction private func exit(_ sender: UIButton) {
        
    }
}
