//
//  Transformer.swift
//  Tracker
//
//  Created by Николай Жирнов on 28.04.2025.
//

import UIKit

final class Transformer {
    static func map(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = categoryCoreData.header,
              let trackersCoreData = categoryCoreData.trackers as? Set<TrackerCoreData> else {
            throw TrackerCategoryStoreError.decodingErrorInvalidData
        }
        
        var trackers: [Tracker] = []
        for trackerCoreData in trackersCoreData {
            if let tracker = try? map(from: trackerCoreData) {
                trackers.append(tracker)
            }
        }
        
        return TrackerCategory(header: name, trackers: trackers)
    }
    
    static func map(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let name = trackerCoreData.name,
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
    
    static func colorToHexString(_ color: UIColor) -> String {
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
    
    static func hexStringToColor(_ hex: String) -> UIColor {
        var colorString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    static func scheduleToString(_ schedule: Set<WeekDay>) -> String {
        return schedule.map { String($0.rawValue) }.joined(separator: ",")
    }
    
    static func stringToSchedule(_ scheduleString: String) -> Set<WeekDay> {
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
