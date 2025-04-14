//
//  HeaderTrackersView.swift
//  Tracker
//
//  Created by Николай Жирнов on 03.04.2025.
//

import UIKit

class HeaderTrackersView: UICollectionReusableView {
    
    // MARK: - Private view properties
    
    lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerTitle)
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
