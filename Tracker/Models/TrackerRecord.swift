//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Николай Жирнов on 29.03.2025.
//

import UIKit

struct TrackerRecord {
    let id: UUID
    let tracker: Tracker
    let date: Date
    
    init(tracker: Tracker, date: Date) {
        self.id = UUID()
        self.tracker = tracker
        self.date = date
    }
}
