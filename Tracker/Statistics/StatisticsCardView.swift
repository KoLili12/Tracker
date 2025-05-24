//
//  StatisticsCardView.swift
//  Tracker
//
//  Created by Николай Жирнов on 23.05.2025.
//

import UIKit

class StatisticsCardView: UIView {
    
    // MARK: - UI Properties
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gradientBorder = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        // Настройка градиентной границы
        gradientBorder.colors = [
            UIColor(hex: "#FD4C49").cgColor,
            UIColor(hex: "#46E69D").cgColor,
            UIColor(hex: "#007BFA").cgColor
        ]
        gradientBorder.startPoint = CGPoint(x: 0, y: 0.5)
        gradientBorder.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Настройка формы границы
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.0
        
        // Добавляем градиент в качестве маски для shapeLayer
        gradientBorder.mask = shapeLayer
        layer.addSublayer(gradientBorder)
        
        // Добавляем метки
        addSubview(valueLabel)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Обновляем размеры градиента и формы границы
        gradientBorder.frame = bounds
        
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        shapeLayer.path = borderPath.cgPath
    }
    
    // MARK: - Public methods
    
    func configure(value: Int, title: String) {
        valueLabel.text = "\(value)"
        titleLabel.text = title
    }
    
    func updateValue(_ value: Int) {
        valueLabel.text = "\(value)"
    }
}
