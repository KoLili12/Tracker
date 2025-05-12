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
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "header", ascending: false)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    // MARK: - Lifecycle methods
    
    override init() {
        self.context = CoreDataManager.shared.context
    }
    
    // MARK: - Internal functions
    
    func fetchAllCategories() -> [TrackerCategory] {
        let categoriesCoreData = fetchedResultsController.fetchedObjects ?? []
        var categories: [TrackerCategory] = []
        
        for categoryCoreData in categoriesCoreData {
            if let category = try? Transformer.map(from: categoryCoreData) {
                categories.append(category)
            }
        }
        return categories
    }
    
    func addCategory(with name: String) {
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.id = UUID()
        newCategory.header = name
        CoreDataManager.shared.saveContext()
    }
    
    func findCategory(at index: Int) -> TrackerCategory? {
        let nameCategory = fetchedResultsController.fetchedObjects?[index]
        guard let header = nameCategory?.header else { return nil }
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

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateCategories()
    }
}

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidData
    case failedToAddTracker
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func updateCategories()
}
