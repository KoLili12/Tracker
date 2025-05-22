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
    private weak var trackerStore: TrackerStore?
    
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
    
    init(trackerStore: TrackerStore) {
        self.trackerStore = trackerStore
        self.context = CoreDataManager.shared.context
        super.init()
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
        guard let trackerStore = trackerStore,
              let sections = trackerStore.fetchedResultsController.sections,
              index < sections.count else {
            print("Ошибка: индекс \(index) выходит за границы массива секций (количество: \(trackerStore?.fetchedResultsController.sections?.count ?? 0))")
            return nil
        }
        
        let nameCategory = sections[index]
        let header = nameCategory.name
        
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "header == %@", header)
        do {
            let categories = try context.fetch(request)
            guard let category = categories.first else { return nil }
            return try Transformer.map(from: category)
        } catch {
            print("Ошибка при поиске категории: \(error)")
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
