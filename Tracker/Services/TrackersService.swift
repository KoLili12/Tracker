//
//  TrackersService.swift
//  Tracker
//
//  Created by Николай Жирнов on 03.04.2025.
//

import UIKit

final class TrackersService: TrackersServiceProtocol {
    
    // MARK: - Private properties
    
    private let trackerStore = TrackerStore()
    private lazy var trackerCategoryStore = TrackerCategoryStore(trackerStore: trackerStore)
    private let trackerRecordStore = TrackerRecordStore()
    
    var countCategory: Int {
        trackerStore.countSection
    }
    
    weak var delegate: TrackerUpdateDelegate?
    
    init() {
        trackerStore.delegate = self
    }
    
    // MARK: - Internal properties
    
    func findCategory(at index: Int) -> TrackerCategory? {
        trackerCategoryStore.findCategory(at: index)
    }
    
    func findTracker(at indexPath: IndexPath) -> Tracker? {
        trackerStore.findTracker(at: indexPath)
    }
    
    func countTrackerInCategory(index: Int) -> Int {
        trackerStore.countTrackerInCategory(index: index)
    }
    
    func getCategories() -> [TrackerCategory] {
        trackerCategoryStore.fetchAllCategories()
    }
    
    func addTrackers(tracker: Tracker, for categoryName: String) {
        trackerStore.addTrackers(tracker: tracker, for: categoryName)
    }
    
    func deleteTracker(index: IndexPath) {
        trackerStore.deleteTracker(index: index)
    }
    
    func pinUnpinTracker(id: UUID) {
        trackerStore.pinUnpinTracker(id: id)
    }
    
    func getCountСategories() -> Int {
        trackerStore.countSection
    }
    
    func getCountTrackers(in categoryIndex: Int) -> Int {
        trackerCategoryStore.fetchAllCategories()[categoryIndex].trackers.count
    }
    
    func getCategory(index: Int) -> TrackerCategory {
        trackerCategoryStore.fetchAllCategories()[index]
    }
    
    func addCompletedTracker(tracker: Tracker, date: Date) {
        trackerRecordStore.addCompletedTracker(tracker: tracker, date: date)
    }
    
    func deleteCompletedTracker(tracker: Tracker, date: Date) {
        trackerRecordStore.deleteCompletedTracker(tracker: tracker, date: date)
    }
    
    func isTrackerCompleted(tracker: Tracker, date: Date) -> Bool {
        trackerRecordStore.isTrackerCompleted(tracker: tracker, date: date)
    }
    
    func countTrackerCompletedTrackers(tracker: Tracker) -> Int {
        trackerRecordStore.countTrackerCompletedTrackers(tracker: tracker)
    }
    
    func filterTrackers(for date: Date?, searchText: String?, category: String?, completed: Bool?) {
        trackerStore.filterTrackers(for: date, searchText: searchText, category: category, completed: completed)
    }
}

extension TrackersService: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        delegate?.updateCollection(store, didUpdate: update)
    }
    
    func updateFullCollection() {
        delegate?.updateFullCollection()
    }
}

