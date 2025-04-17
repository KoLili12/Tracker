//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Николай Жирнов on 17.04.2025.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    let selectionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(selectionView)
        selectionView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            selectionView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            selectionView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            selectionView.widthAnchor.constraint(equalToConstant: 52),
            selectionView.heightAnchor.constraint(equalToConstant: 52),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: selectionView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: selectionView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
