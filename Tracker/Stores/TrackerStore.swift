//
//  TrackerStore.swift
//  Tracker
//
//  Created by Николай Жирнов on 22.04.2025.
//

import UIKit
import CoreData


final class TrackerStore: NSObject {
    let context: NSManagedObjectContext
    
    override init() {
        self.context = CoreDataManager.shared.context
    }
    
    func addTrackers(tracker: Tracker, for categoryName: String) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "header == %@", categoryName)
        
        do {
            // Ищем категорию
            let categories = try context.fetch(request)
            let categoryCoreData: TrackerCategoryCoreData
            
            // Если категория не найдена, создаем новую
            if let existingCategory = categories.first {
                categoryCoreData = existingCategory
            } else {
                categoryCoreData = TrackerCategoryCoreData(context: context)
                categoryCoreData.header = categoryName
            }
            
            // Создаем объект трекера в CoreData
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.name = tracker.name
            trackerCoreData.emoji = tracker.emoji
            
            // Сохраняем цвет как строку (необходимо реализовать конвертацию)
            trackerCoreData.colorHex = colorToHexString(tracker.color)
            
            // Сохраняем расписание как строку (необходимо реализовать конвертацию)
            trackerCoreData.schedule = scheduleToString(tracker.schedule)
            
            // Связываем трекер с категорией
            trackerCoreData.category = categoryCoreData
            
            // Сохраняем изменения
            try context.save()
            
        } catch {
            print("Ошибка при добавлении трекера: \(error)")
        }
    }
    
    func fetchTrackers() -> [Tracker] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        do {
            let trackersCoreData = try context.fetch(fetchRequest)
            var trackers: [Tracker] = []
            
            for trackerCoreData in trackersCoreData {
                if let tracker = try? map(from: trackerCoreData) {
                    trackers.append(tracker)
                }
            }
            
            return trackers
        } catch {
            print("Ошибка при получении трекеров: \(error)")
            return []
        }
    }
    
    func map(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id,
              let name = trackerCoreData.name,
              let emoji = trackerCoreData.emoji,
              let colorHex = trackerCoreData.colorHex,
              let scheduleString = trackerCoreData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidData
        }
        
        let color = hexStringToColor(colorHex)
        let schedule = stringToSchedule(scheduleString)
        
        return Tracker(
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
    }

    // Вспомогательные функции для конвертации данных
    private func colorToHexString(_ color: UIColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "#%02X%02X%02X",
            Int(r * 255),
            Int(g * 255),
            Int(b * 255)
        )
    }
    
    private func hexStringToColor(_ hex: String) -> UIColor {
        var colorString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    private func scheduleToString(_ schedule: Set<WeekDay>) -> String {
        return schedule.map { String($0.rawValue) }.joined(separator: ",")
    }
    
    private func stringToSchedule(_ scheduleString: String) -> Set<WeekDay> {
        let weekdayStrings = scheduleString.components(separatedBy: ",")
        var weekdays: Set<WeekDay> = []
        
        for weekdayString in weekdayStrings {
            if let rawValue = Int(weekdayString), let weekday = WeekDay(rawValue: rawValue) {
                weekdays.insert(weekday)
            }
        }
        
        return weekdays
    }
}

enum TrackerStoreError: Error {
    case decodingErrorInvalidData
}
