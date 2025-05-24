//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 10.04.2025.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let scheduleUI: [String] = [
        NSLocalizedString("monday", comment: "Monday"),
        NSLocalizedString("tuesday", comment: "Tuesday"),
        NSLocalizedString("wednesday", comment: "Wednesday"),
        NSLocalizedString("thursday", comment: "Thursday"),
        NSLocalizedString("friday", comment: "Friday"),
        NSLocalizedString("saturday", comment: "Saturday"),
        NSLocalizedString("sunday", comment: "Sunday")
    ]
    private var schedule: Set<WeekDay>
    
    // MARK: - Internal properties
    
    weak var delegate: AddHabitViewControllerDelegate?
    
    // MARK: - Private view properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = UIColor(named: "TrackerWhite")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Init
    
    init(schedule: Set<WeekDay>) {
        self.schedule = schedule
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "TrackerWhite")
        
        navigationItem.title = NSLocalizedString("schedule", comment: "schedule")
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        tableView.delegate = self
        tableView.dataSource = self
        
        let doneButton = createDoneButton()
        
        
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -10),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        tableView.reloadData()
    }
    
    // MARK: - Private create buttons functions
    
    private func createDoneButton() -> UIButton {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setTitle(NSLocalizedString("done", comment: "done"), for: .normal)
        button.backgroundColor = UIColor(named: "TrackerBlack")
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor(named: "TrackerWhite"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
        ])
        return button
    }
    
    // MARK: - @objc private functions
    
    @objc private func switchValueDidChange(_ sender: UISwitch) {
        guard let weekday = convertToWeekDay(sender.tag) else { return }
        if sender.isOn {
            addWeekdayToSchedule(weekday)
        }
        else {
            removeWeekdayFromSchedule(weekday)
        }
    }
    
    @objc private func doneButtonTapped() {
        delegate?.reloadData(newSchedule: schedule)
        dismiss(animated: true)
    }
    
    // MARK: - Private functions
    
    private func convertToWeekDay(_ index: Int) -> WeekDay? {
        var row = index + 2  // Получаем индекс из tag переключателя
        if row == 8 { row = 1 }
        
        guard let weekday = WeekDay(rawValue: row) else {
            print("switchValueDidChange(_ sender: UISwitch): ошибка неверный индекс")
            return nil
        } // Получаем день недели по индексу
        return weekday
    }
    
    private func weekdayInSchedule(_ weekday: WeekDay) -> Bool {
        schedule.contains(weekday)
    }
    
    private func addWeekdayToSchedule(_ weekday: WeekDay) {
        schedule.insert(weekday)
    }
    
    private func removeWeekdayFromSchedule(_ weekday: WeekDay) {
        schedule.remove(weekday)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        scheduleUI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        if  traitCollection.userInterfaceStyle == .light {
            cell.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 250/255, alpha: 1.0)
        } else {
            cell.backgroundColor = .darkTextField
        }
        cell.selectionStyle = .none
        let switchView = UISwitch()
        
        guard let weekday = convertToWeekDay(indexPath.row) else {
            print("tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath): ошибка неверный индекс")
            return cell
        }
        
        switchView.isOn = weekdayInSchedule(weekday) // Установите начальное состояние
        switchView.onTintColor = UIColor(named: "TrackerBlue")// Цвет активного состояния
        switchView.tag = indexPath.row // Пометка для идентификации при обработке событий
        switchView.addTarget(self, action: #selector(switchValueDidChange(_ :)), for: .valueChanged)
        cell.accessoryView = switchView
        cell.textLabel?.text = scheduleUI[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
