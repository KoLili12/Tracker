//
//  AddHabitViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 09.04.2025.
//

import UIKit

final class AddHabitViewController: BaseAddTrackerViewController {
    
    // MARK: - Private properties
    
    private let tableViewData: [String] = [
        NSLocalizedString("category", comment: "category"),
        NSLocalizedString("schedule", comment: "schedule")
    ]
    
    // MARK: - Methods overridden from BaseAddTrackerViewController
    
    override func getNavigationTitle() -> String {
        return isEditMode ? NSLocalizedString("editHabit", comment: "editHabit") :NSLocalizedString("newHabit", comment: "newHabit")
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
            let vc = CategoriesViewController()
            vc.viewModel = CategoriesViewModel()
            vc.viewModel?.delegate = self
            let nc = UINavigationController(rootViewController: vc)
            present(nc, animated: true)
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
            return  NSLocalizedString("everyday", comment: "everyday")
        }
        let dayNames: [WeekDay: String] = [
            .monday: NSLocalizedString("mon", comment: "mon"),
            .tuesday: NSLocalizedString("tue", comment: "tue"),
            .wednesday: NSLocalizedString("wed", comment: "wed"),
            .thursday: NSLocalizedString("thu", comment: "thu"),
            .friday: NSLocalizedString("fri", comment: "fri"),
            .saturday: NSLocalizedString("sat", comment: "sat"),
            .sunday: NSLocalizedString("sun", comment: "sun")
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
