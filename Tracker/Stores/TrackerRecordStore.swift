//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Николай Жирнов on 22.04.2025.
//

import Foundation
import CoreData

final class TrackerRecordStore: NSObject {
    
    // MARK: - Private properties
    
    private var context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
    // MARK: - Lifecycle methods
    
    override init() {
        self.context = CoreDataManager.shared.context
    }
    
    // MARK: - Internal functions
    
    func addCompletedTracker(tracker: Tracker, date: Date) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            let trackers = try context.fetch(request)
            
            // Проверяем, найден ли трекер
            guard let trackerCoreData = trackers.first else {
                print("Ошибка: трекер с id \(tracker.id) не найден в базе данных")
                return
            }
            
            // Создаем запись о выполнении
            let completedTracker = TrackerRecordCoreData(context: context)
            completedTracker.id = UUID()
            completedTracker.tracker = trackerCoreData
            completedTracker.date = date
            
            // Сохраняем контекст
            CoreDataManager.shared.saveContext()
            
        } catch {
            print("Ошибка при добавлении выполненного трекера: \(error)")
        }
    }
    
    func deleteCompletedTracker(tracker: Tracker, date: Date) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", tracker.id as CVarArg, date as CVarArg)
        do {
            let records = try context.fetch(request)
            
            guard let recordCoreData = records.first else {
                print("Ошибка: record не найден в базе данных")
                return
            }
            
            context.delete(recordCoreData)
            CoreDataManager.shared.saveContext()
        } catch {
            print("Ошибка при удалении выполненного трекера: \(error)")
        }
    }
    
    func isTrackerCompleted(tracker: Tracker, date: Date) -> Bool {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", tracker.id as CVarArg, date as CVarArg)
        do {
            let records = try context.fetch(request)
            return !records.isEmpty
        } catch {
            print("Ошибка при проверке состояния трекера: \(error)")
            return false
        }
    }
    
    func countTrackerCompletedTrackers(tracker: Tracker) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "tracker.id == %@", tracker.id as CVarArg)
        do {
            let records = try context.fetch(request)
            return records.count
        } catch {
            print("Ошибка при подсчете завершенных трекеров: \(error)")
            return 0
        }
    }
}
