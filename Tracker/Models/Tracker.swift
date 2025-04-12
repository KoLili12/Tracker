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
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDay>
    
    init(
         name: String,
         color: UIColor,
         emoji: String,
         schedule: Set<WeekDay>
    ) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
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
