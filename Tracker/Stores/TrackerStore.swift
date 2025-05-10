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
    private var insertedSections: IndexSet = []
    private var deletedSections: IndexSet = []
    
    // MARK: - Internal properties

    lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [
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
    
    // Добавим метод для обновления предиката и перезагрузки данных по выбранному дню недели
    func filterTrackers(for date: Date) {
        // Получаем номер дня недели из даты
        let calendar = Calendar.current
        guard let weekday = WeekDay(rawValue: calendar.component(.weekday, from: date)) else {
            return
        }
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        
        // Создаем предикат для фильтрации по дню недели
        // Используем CONTAINS для проверки, содержит ли строка schedule номер дня недели
        let weekdayString = String(weekday.rawValue)
        let predicate = NSPredicate(format: "schedule CONTAINS %@", weekdayString)
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.header",
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = []
        insertedSections = []
        deletedSections = []
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerStoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes,
                insertedSections: insertedSections,
                deletedSections: deletedSections
            )
        )
        insertedIndexes = []
        deletedIndexes = []
        insertedSections = []
        deletedSections = []
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
        case .update, .move:
            print()
        default:
            fatalError()
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
            default:
                fatalError()
            }
        }
}
