//
//  TrackersService.swift
//  Tracker
//
//  Created by Николай Жирнов on 03.04.2025.
//

import UIKit

final class TrackersService: TrackersServiceProtocol {
    
    // MARK: - Private properties
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(header: "Домашний уют", trackers: [
            Tracker(
                name: "Поливать растения",
                color: UIColor(named: "TrackerGreen") ?? UIColor(),
                emoji: "❤️",
                schedule: [.monday, .thursday, .sunday, .wednesday]
            ),
            Tracker(
                name: "Кошка заслонила камеру на созвоне",
                color: UIColor(named: "TrackerRed") ?? UIColor(),
                emoji: "🌺",
                schedule: [.thursday, .friday]
            )
           ]
        ),
        TrackerCategory(header: "Радостные мелочи", trackers: [
            Tracker(
                name: "Бабушка прислала открытку в вотсапе",
                color: UIColor(named: "TrackerOrange") ?? UIColor(),
                emoji: "😻",
                schedule: [.monday, .thursday, .friday]
            )
           ]
        )
    ]

    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Internal properties
    
    func addCategory(_ category: TrackerCategory) {
        
    }
    
    func getCategories() -> [TrackerCategory] {
        return categories
    }
    
    func addTrackers(tracker: Tracker, for categoryName: String) {
        var newCategories: [TrackerCategory] = []
        var flag = false // есть ли новая категория в categories?
        categories.forEach { category in
            if category.header == categoryName {
                let newCategory = TrackerCategory(header: category.header, trackers: category.trackers + [tracker])
                newCategories.append(newCategory)
                flag = true
            } else {
                newCategories.append(category)
            }
        }
        
        if !flag {
            newCategories.append(TrackerCategory(header: categoryName, trackers: [tracker]))
        }
        categories = newCategories
    }
    
    func getCountСategories() -> Int {
        return categories.count
    }
    
    func getCountTrackers(in categoryIndex: Int) -> Int {
        return categories[categoryIndex].trackers.count
    }
    
    func getTracker(in categoryIndex: Int, at trackIndex: Int) -> Tracker {
        return categories[categoryIndex].trackers[trackIndex]
    }
    
    func getCatergory(index: Int) -> TrackerCategory {
        return categories[index]
    }
    
    func addCompletedTracker(tracker: Tracker, date: Date) {
        let trackerRecord = TrackerRecord(tracker: tracker, date: date)
        completedTrackers.append(trackerRecord)
    }
    
    func deleteCompletedTracker(tracker: Tracker, date: Date) {
        completedTrackers.removeAll { $0.tracker.name == tracker.name && $0.date == date }
    }
    
    func isTrackerCompleted(tracker: Tracker, date: Date) -> Bool {
        return completedTrackers.contains { record in
            print(record.date, date)
            return record.tracker.name == tracker.name && record.date == date
        }
    }
    
    func countTrackerCompletedTrackers(tracker: Tracker) -> Int {
        return completedTrackers.count(where: { $0.tracker.id == tracker.id })
    }
}
