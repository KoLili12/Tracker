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
        return NSLocalizedString("newIrregularEvent", comment: "newIrregularEvent")
    }
    
    override func getTableData() -> [String] {
        return [NSLocalizedString("category", comment: "category")]
    }
    
    override func configureCellDetails(_ cell: UITableViewCell, at indexPath: IndexPath) {
        cell.detailTextLabel?.text = trackerCategory
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = UIColor(named: "TrackerGray")
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // TODO: - Добавить переход на экран выбора категории
            let vc = CategoriesViewController()
            vc.viewModel = CategoriesViewModel()
            vc.viewModel?.delegate = self
            let nc = UINavigationController(rootViewController: vc)
            present(nc, animated: true)
        }
    }
}
