//
//  TrackersServiceProtocol.swift
//  Tracker
//
//  Created by Николай Жирнов on 14.04.2025.
//

import Foundation

protocol TrackersServiceProtocol {
    var delegate: TrackerUpdateDelegate? { get set }
    var countCategory: Int { get }
    func findCategory(at index: Int) -> TrackerCategory?
    func findTracker(at indexPath: IndexPath) -> Tracker?
    func countTrackerInCategory(index: Int) -> Int
    func getCategories() -> [TrackerCategory]
    func addTrackers(tracker: Tracker, for categoryName: String)
    func getCountСategories() -> Int
    func getCountTrackers(in categoryIndex: Int) -> Int
    func getCategory(index: Int) -> TrackerCategory
    func addCompletedTracker(tracker: Tracker, date: Date)
    func deleteCompletedTracker(tracker: Tracker, date: Date)
    func isTrackerCompleted(tracker: Tracker, date: Date) -> Bool
    func countTrackerCompletedTrackers(tracker: Tracker) -> Int
    func filterTrackers(for date: Date)
}
