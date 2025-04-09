//
//  Tracker.swift
//  Tracker
//
//  Created by Николай Жирнов on 29.03.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let type: TrackerType
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    
    init(
         name: String,
         type: TrackerType,
         color: UIColor,
         emoji: String,
         schedule: [WeekDay]
    ) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}

enum TrackerType {
    case habit        // Привычка
    case irregularEvent  // Нерегулярное событие
}

enum WeekDay: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}
