//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Николай Жирнов on 02.04.2025.
//

import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Internal properties
    
    lazy var cardView: UIImageView = {
        let card = UIImageView()
        card.backgroundColor = .red
        card.layer.cornerRadius = 16
        card.contentMode = .scaleAspectFit
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.widthAnchor.constraint(equalToConstant: 167),
            card.heightAnchor.constraint(equalToConstant: 90)
        ])
        return card
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Бабушка прислала открытку в вотсапе"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    lazy var circleBackgroundEmojiLabel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 24),
            view.heightAnchor.constraint(equalToConstant: 24)
        ])
        return view
    }()
    
    lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "❤️"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.tintColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var countDaysLabel: UILabel = {
        let label = UILabel()
        label.text = "5 дней"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let markTrackerButton = createMarkTrackerButton()
        
        contentView.addSubview(cardView)
        contentView.addSubview(markTrackerButton)
        contentView.addSubview(countDaysLabel)
        
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(circleBackgroundEmojiLabel)
        
        circleBackgroundEmojiLabel.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: circleBackgroundEmojiLabel.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: circleBackgroundEmojiLabel.centerYAnchor)
            ])
        
        NSLayoutConstraint.activate([
            circleBackgroundEmojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            circleBackgroundEmojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -15),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -13),
            ])
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            markTrackerButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            markTrackerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            countDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countDaysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private functions
    
    private func createMarkTrackerButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapMarkTrackerButton), for: .touchUpInside)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 17
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34)
        ])
        return button
    }
    
    @objc private func didTapMarkTrackerButton() {
        print(5)
    }
}
