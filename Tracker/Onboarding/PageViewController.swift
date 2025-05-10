//
//  PageViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 09.05.2025.
//

import UIKit

class PageViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        imageView.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 432),
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16)
        ])
    }

}
