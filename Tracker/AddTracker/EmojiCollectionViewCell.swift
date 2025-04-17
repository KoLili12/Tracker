//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Николай Жирнов on 16.04.2025.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI properties
    
    let selectionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "TrackerWhite")
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 52),
            view.heightAnchor.constraint(equalToConstant: 52)
        ])
        return view
    }()
    
    // MARK: - Init
    
    let emojiLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(selectionView)
        selectionView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            selectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: selectionView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: selectionView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
