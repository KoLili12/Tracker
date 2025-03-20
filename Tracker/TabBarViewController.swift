//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 20.03.2025.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private lazy var TabBarSeparator: UIView = {
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        lineView.backgroundColor = UIColor(named: "TrackerGray")
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersViewController = TrackersViewController()
        let statisticsViewController = StatisticsViewController()
        
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackerTabBarItem"),
            selectedImage: nil
        )
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatisticsTabBarItem"),
            selectedImage: nil
        )
        
        trackersViewController.tabBarItem.imageInsets =  UIEdgeInsets(top: 9.57, left: 6, bottom: 9.12, right: 6)
        statisticsViewController.tabBarItem.imageInsets =  UIEdgeInsets(top: 5, left: 28, bottom: 5.37, right: 28)
        
        self.viewControllers = [trackersViewController, statisticsViewController]
        
        tabBar.addSubview(TabBarSeparator)
        
        NSLayoutConstraint.activate([
            TabBarSeparator.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            TabBarSeparator.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            TabBarSeparator.topAnchor.constraint(equalTo: tabBar.topAnchor),
            TabBarSeparator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
