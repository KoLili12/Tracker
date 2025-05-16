//
//  ChooseTrackerTypeViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 09.04.2025.
//

import UIKit

final class ChooseTrackerTypeViewController: UIViewController {
    
    // MARK: - Private view properties
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let addHabitButton = createAddHabitButton()
        let addIrregularEventsButton = createAddIrregularEventButton()
        
        navigationItem.title = NSLocalizedString("createTracker", comment: "createTracker")
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(addHabitButton)
        stackView.addArrangedSubview(addIrregularEventsButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Private create buttons functions
    
    private func createAddHabitButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("addHabit", comment: "addHabit"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "TrackerBlack")
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addHabitButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return button
    }
    
    private func createAddIrregularEventButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("irregularEvent", comment: "irregularEvent"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "TrackerBlack")
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addIrregularEventsButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return button
    }
    
    // MARK: - @objc private functions
    
    @objc private func addHabitButtonTapped() {
        let vc = AddHabitViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
    
    @objc private func addIrregularEventsButtonTapped() {
        let vc = AddIrregularEventViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
}
