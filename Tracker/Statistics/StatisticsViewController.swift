//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 20.03.2025.
//

import UIKit

// MARK: - UIColor Extension для HEX-цветов
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

final class StatisticsViewController: UIViewController {
    
    let recordStore = TrackerRecordStore()
    
    // MARK: - UI properties
    
    private lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistics", comment: "statistics") /*"Статистика"*/
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plugImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "NoStatistics"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        return imageView
    }()
    
    private lazy var plugLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statisticsPlugText", comment: "statisticsPlugText")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countCompletedTracker = createStatisticsView(value: 0, title: NSLocalizedString("trackersCompleted", comment: "trackersCompleted"))
    
    // MARK: - Override func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "TrackerWhite")
        
        view.addSubview(trackerLabel)
        view.addSubview(countCompletedTracker)
        view.addSubview(plugImageView)
        view.addSubview(plugLabel)
        
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            countCompletedTracker.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 77),
            countCompletedTracker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            countCompletedTracker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            plugImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            plugLabel.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    // MARK: - Private functions
    
    private func createStatisticsView(value: Int, title: String) -> StatisticsCardView {
        let containerView = StatisticsCardView()
        containerView.configure(value: value, title: title)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        return containerView
    }
    
    private func updateUI() {
        let completedCount = recordStore.countTrackerCompletedTrackers()
        
        let hasStatistics = completedCount > 0
        countCompletedTracker.isHidden = !hasStatistics
        plugImageView.isHidden = hasStatistics
        plugLabel.isHidden = hasStatistics
        
        if hasStatistics {
            countCompletedTracker.updateValue(completedCount)
        }
    }
}
