//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Николай Жирнов on 29.03.2025.
//

import Foundation

struct TrackerRecord {
    let id: UUID = UUID()
    let tracker: Tracker
    let date: Date
}
