//
//  ViewController.swift
//  ImageFeed
//
//  Created by Ramil Yanberdin on 17.03.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    // Энум для названия картинок кнопки лайка
    enum LikeButtonNames: String {
        case activeLike
        case inactiveLike
    }
    // Предопределяем статус бар в темной теме
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }


}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ImagesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifer, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        // Инициализируем основную картинку
        guard let contentImage = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        cell.contentImage.image = contentImage
        
        // Инициализируем текущую дату в лейбл
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        // Инициализируем картинку для кнопки лайка
        guard let activeLike = UIImage(named: LikeButtonNames.activeLike.rawValue),
              let inactiveLike = UIImage(named: LikeButtonNames.inactiveLike.rawValue) else {
            return
        }
        if indexPath.row % 2 != 0 {
            cell.likeButton.setImage(activeLike, for: .normal)
        } else {
            cell.likeButton.setImage(inactiveLike, for: .normal)
        }
        cell.likeButton.setTitle(String(), for: .normal)
    }
}
