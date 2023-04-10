//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 03.04.2023.
//

import UIKit

final class ProfileViewController: BaseViewController {

    private var userpic: CircularImageView?
    private var name: UILabel?
    private var username: UILabel?
    private var exitButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        makeProfilePage()
    }

    private func addUserpic(named: String) {
        userpic = CircularImageView()
        guard let userpic else { return }

        userpic.image = UIImage(named: named)
        userpic.layer.masksToBounds = true

        self.view.addSubview(userpic)

        userpic.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userpic.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 76),
            userpic.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 18),
            userpic.widthAnchor.constraint(equalToConstant: 70),
            userpic.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func addName(named: String) {
        name = UILabel()
        guard let name,
              let userpic else { return }

        name.text = named
        name.textColor = .ypWhite
        name.font = UIFont(name: "SF Pro Text Bold", size: 23)

        self.view.addSubview(name)

        name.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: userpic.bottomAnchor, constant: 8),
            name.leadingAnchor.constraint(equalTo: userpic.leadingAnchor)
        ])
    }

    private func addUsername(named: String) {
        username = UILabel()
        guard let username,
              let name else { return }

        username.text = named
        username.textColor = .ypGray
        username.font = UIFont(name: "SF Pro Text Regular", size: 13)

        self.view.addSubview(username)

        username.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            username.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            username.leadingAnchor.constraint(equalTo: name.leadingAnchor)
        ])
    }

    private func addExitButton() {
        exitButton = UIButton()
        guard let exitButton,
              let userpic else { return }

        exitButton.setImage(UIImage(named: "exit"), for: .normal)

        self.view.addSubview(exitButton)

        exitButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            exitButton.centerYAnchor.constraint(equalTo: userpic.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -26),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    fileprivate func makeProfilePage() {
        self.view.backgroundColor = .ypBlack

        addUserpic(named: "myImage")
        addName(named: "Рамиль Янбердин")
        addUsername(named: "@yanram")
        addExitButton()
    }

}
