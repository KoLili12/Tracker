//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Николай Жирнов on 22.04.2025.
//

import UIKit
import CoreData


final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
    override init() {
        self.context = CoreDataManager.shared.context
    }
    
    func createCategory(from category: TrackerCategory) {
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.header = category.header
        CoreDataManager.shared.saveContext()
    }
    
    func fetchAllCategories() -> [TrackerCategory] {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        do {
            let categoriesData = try context.fetch(request)
            var result: [TrackerCategory] = []
            for category in categoriesData {
                result.append(try map(from: category))
            }
            return result
            
        } catch {
            print("Fetching error: \(error)")
            return []
        }
    }
    
    
    
    func map(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = categoryCoreData.header,
              let trackersCoreData = categoryCoreData.trackers as? Set<TrackerCoreData> else {
            throw TrackerCategoryStoreError.decodingErrorInvalidData
        }
        
        var trackers: [Tracker] = []
        for trackerCoreData in trackersCoreData {
            if let tracker = try? trackerStore.map(from: trackerCoreData) {
                trackers.append(tracker)
            }
        }
        
        return TrackerCategory(header: name, trackers: trackers)
    }
    
    
}


enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidData
    case failedToAddTracker
}
