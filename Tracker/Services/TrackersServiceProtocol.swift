//
//  TrackersServiceProtocol.swift
//  Tracker
//
//  Created by Николай Жирнов on 14.04.2025.
//

import Foundation

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
