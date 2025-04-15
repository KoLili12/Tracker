//
//  AddHabitViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 09.04.2025.
//

import UIKit

final class AddHabitViewController: BaseAddTrackerViewController {
    
    // MARK: - Private properties
    
    private let tableViewData: [String] = ["Категория", "Расписание"]
    
    // MARK: - Methods overridden from BaseAddTrackerViewController
    
    override func getNavigationTitle() -> String {
        return "Новая привычка"
    }
    
    override func getTableData() -> [String] {
        return tableViewData
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 { // Расписание
            let vc = ScheduleViewController(schedule: trackerSchedule)
            vc.delegate = self
            let nc = UINavigationController(rootViewController: vc)
            present(nc, animated: true)
        } else { // Категория
            // TODO: - Добавить переход на экран выбора категории
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func configureCellDetails(_ cell: UITableViewCell, at indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = trackerCategory
        } else {
            cell.detailTextLabel?.text = createScheduleText()
        }
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = UIColor(named: "TrackerGray")
    }
    
    // MARK: - Private helper methods
    
    private func createScheduleText() -> String {
        if trackerSchedule.count == 7 {
            return "Каждый день"
        }
        let dayNames: [WeekDay: String] = [
            .monday: "Пн",
            .tuesday: "Вт",
            .wednesday: "Ср",
            .thursday: "Чт",
            .friday: "Пт",
            .saturday: "Сб",
            .sunday: "Вс"
        ]
        let sortedDays = trackerSchedule.sorted { $0.rawValue < $1.rawValue }
        let dayStrings = sortedDays.compactMap { dayNames[$0] }
        return dayStrings.isEmpty ? "" : dayStrings.joined(separator: ", ")
    }
}

// MARK: - AddHabitViewControllerDelegate

extension AddHabitViewController: AddHabitViewControllerDelegate {
    func reloadData(newSchedule: Set<WeekDay>) {
        trackerSchedule = newSchedule
        checkStateButton()
        tableView.reloadData()
    }
}
