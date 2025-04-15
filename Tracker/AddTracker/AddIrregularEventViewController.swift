//
//  AddIrregularEventViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 14.04.2025.
//

import UIKit

final class AddIrregularEventViewController: BaseAddTrackerViewController {
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        // Set all weekdays before calling super
        trackerSchedule = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        super.viewDidLoad()
    }
    
    override func getNavigationTitle() -> String {
        return "Новое нерегулярное событие"
    }
    
    override func getTableData() -> [String] {
        return ["Категория"]
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // TODO: - Добавить переход на экран выбора категории
        }
    }
}
