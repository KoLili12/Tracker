//
//  Tracker.swift
//  Tracker
//
//  Created by Николай Жирнов on 29.03.2025.
//

import UIKit

struct Tracker {
    let id: UUID = UUID()
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDay>
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
