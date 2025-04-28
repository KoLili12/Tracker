//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Николай Жирнов on 22.04.2025.
//

import UIKit
import CoreData


final class TrackerCategoryStore: NSObject {
    
    // MARK: - Private properties
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
    // MARK: - Lifecycle methods
    
    override init() {
        self.context = CoreDataManager.shared.context
    }
    
    // MARK: - Internal functions
    
    func createCategory(from category: TrackerCategory) {
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.id = UUID()
        newCategory.header = category.header
        CoreDataManager.shared.saveContext()
    }
    
    func fetchAllCategories() -> [TrackerCategory] {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        do {
            let categoriesData = try context.fetch(request)
            var result: [TrackerCategory] = []
            for category in categoriesData {
                result.append(try Transformer.map(from: category))
            }
            return result
        } catch {
            print("Fetching error: \(error)")
            return []
        }
    }
    
    func findCategory(at index: Int) -> TrackerCategory? {
        let nameCategory = trackerStore.fetchedResultsController.sections?[index]
        guard let header = nameCategory?.name else { return nil }
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "header == %@", header)
        do {
            let categories = try context.fetch(request)
            if categories.count > 0 {
                guard let category = categories.first else {return nil}
                return try Optional(Transformer.map(from: category))
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidData
    case failedToAddTracker
}
