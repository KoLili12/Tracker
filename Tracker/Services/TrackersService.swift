//
//  TrackersService.swift
//  Tracker
//
//  Created by Николай Жирнов on 03.04.2025.
//

import UIKit

protocol TrackersServiceProtocol {
    func addCategory(_ category: TrackerCategory)
    func getCategories() -> [TrackerCategory]
    func addTrackers(tracker: Tracker, for categoryName: String)
    func getCountСategories() -> Int
    func getCountTrackers(in categoryIndex: Int) -> Int
    func getTracker(in categoryIndex: Int, at trackIndex: Int) -> Tracker
    func getCatergory(index: Int) -> TrackerCategory
    func addCompletedTracker(tracker: Tracker, date: Date)
    func deleteCompletedTracker(tracker: Tracker, date: Date)
    func isTrackerCompleted(tracker: Tracker, date: Date) -> Bool
    func countTrackerCompletedTrackers(tracker: Tracker) -> Int
}


final class TrackersService: TrackersServiceProtocol {
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(header: "Домашний уют", trackers: [
            Tracker(
                name: "Поливать растения",
                type: .habit,
                color: UIColor(named: "TrackerGreen") ?? UIColor(),
                emoji: "❤️",
                schedule: [.monday, .thursday, .sunday]
            ),
            Tracker(
                name: "Кошка заслонила камеру на созвоне",
                type: .habit,
                color: UIColor(named: "TrackerRed") ?? UIColor(),
                emoji: "🌺",
                schedule: [.thursday, .friday]
            )
           ]
        ),
        TrackerCategory(header: "Радостные мелочи", trackers: [
            Tracker(
                name: "Бабушка прислала открытку в вотсапе",
                type: .habit,
                color: UIColor(named: "TrackerOrange") ?? UIColor(),
                emoji: "😻",
                schedule: [.monday, .thursday, .friday]
            )]
                       )
    ]

    private var completedTrackers: [TrackerRecord] = []
    
    func addCategory(_ category: TrackerCategory) {
        
    }
    
    func getCategories() -> [TrackerCategory] {
        return categories
    }
    
    func addTrackers(tracker: Tracker, for categoryName: String) {
        var newCategories: [TrackerCategory] = []
        categories.forEach { category in
            if category.header == categoryName {
                let newCategory = TrackerCategory(header: category.header, trackers: category.trackers + [tracker])
                newCategories.append(newCategory)
            } else {
                newCategories.append(category)
            }
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
        // Проверяем, есть ли запись о выполнении трекера на указанную дату
        return completedTrackers.contains { record in
            record.tracker.name == tracker.name && record.date == date
        }
    }
    
    func countTrackerCompletedTrackers(tracker: Tracker) -> Int {
        return completedTrackers.count(where: { $0.tracker.name == tracker.name })
    }
}
