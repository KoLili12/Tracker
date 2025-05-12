//
//  TrackerStore.swift
//  Tracker
//
//  Created by Николай Жирнов on 22.04.2025.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidData
}

final class TrackerStore: NSObject {
    
    // MARK: - Private properties
    
    private let context: NSManagedObjectContext
    
    private var insertedIndexes: [IndexPath] = []
    private var deletedIndexes: [IndexPath] = []
    private var updatedIndexes: [IndexPath] = []
    private var insertedSections: IndexSet = []
    private var deletedSections: IndexSet = []
    private var updatedSections: IndexSet = []
    
    // MARK: - Internal properties

    lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.header", ascending: false),
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.header",
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    weak var delegate: TrackerStoreDelegate?
    
    var countSection: Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    // MARK: - Lifecycle methods
    
    override init() {
        self.context = CoreDataManager.shared.context
    }
    
    // MARK: - Internal functions
    
    func countTrackerInCategory(index: Int) -> Int {
        return fetchedResultsController.sections?[index].numberOfObjects ?? 0
    }
    
    func findTracker(at indexPath: IndexPath) -> Tracker? {
        let trackerCoreDate = fetchedResultsController.object(at: indexPath)
        let tracker = try? Transformer.map(from: trackerCoreDate)
        return tracker
    }
    
    func addTrackers(tracker: Tracker, for categoryName: String) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "header == %@", categoryName)
        
        do {
            let categories = try context.fetch(request)
            let categoryCoreData: TrackerCategoryCoreData
            
            // Если категория не найдена, создаем новую
            if let existingCategory = categories.first {
                categoryCoreData = existingCategory
            } else {
                categoryCoreData = TrackerCategoryCoreData(context: context)
                categoryCoreData.id = UUID()
                categoryCoreData.header = categoryName
            }
            
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.createdAt = Date()
            trackerCoreData.name = tracker.name
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.colorHex = Transformer.colorToHexString(tracker.color)
            trackerCoreData.schedule = Transformer.scheduleToString(tracker.schedule)
            
            // Связываем трекер с категорией
            trackerCoreData.category = categoryCoreData
            CoreDataManager.shared.saveContext()
        } catch {
            print("Ошибка при добавлении трекера: \(error)")
        }
    }
    
    func fetchTrackers() -> [Tracker] {
        let trackersCoreData = fetchedResultsController.fetchedObjects ?? []
        var trackers: [Tracker] = []
        
        for trackerCoreData in trackersCoreData {
            if let tracker = try? Transformer.map(from: trackerCoreData) {
                trackers.append(tracker)
            }
        }
        return trackers
    }
    
    func filterTrackers(for date: Date) {
        let calendar = Calendar.current
        guard let weekday = WeekDay(rawValue: calendar.component(.weekday, from: date)) else {
            return
        }
        
        let weekdayString = String(weekday.rawValue)
        let predicate = NSPredicate(format: "schedule CONTAINS %@", weekdayString)
        
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsController.performFetch()
            delegate?.updateFullCollection()
        } catch {
            print("Ошибка при фильтрации трекеров: \(error)")
        }
    }

}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = []
        updatedIndexes = []
        insertedSections = []
        deletedSections = []
        updatedSections = []
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerStoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes,
                updatedIndexes: updatedIndexes,
                insertedSections: insertedSections,
                deletedSections: deletedSections,
                updatedSections: updatedSections
            )
        )
        insertedIndexes = []
        deletedIndexes = []
        updatedIndexes = []
        insertedSections = []
        deletedSections = []
        updatedSections = []
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes.append(indexPath)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes.append(indexPath)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
                updatedIndexes.append(indexPath)
        case .move:
            guard let oldIndexPath = indexPath,
                  let newIndexPath = newIndexPath else { return }
            deletedIndexes.append(oldIndexPath)
            insertedIndexes.append(newIndexPath)
        default:
            break
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
        didChange sectionInfo: any NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType) {
            switch type {
            case .insert:
                insertedSections.insert(sectionIndex)
            case .delete:
                deletedSections.insert(sectionIndex)
            case .update:
                updatedSections.insert(sectionIndex)
            default:
                print("Необработанный тип изменения секции: \(type)")
                fatalError()
            }
        }
}
