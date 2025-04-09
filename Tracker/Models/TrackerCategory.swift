//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Николай Жирнов on 29.03.2025.
//

import UIKit

struct TrackerCategory {
    let id: UUID
    let header: String
    let trackers: [Tracker]
    
    init(header: String, trackers: [Tracker]) {
        self.id = UUID()
        self.header = header
        self.trackers = trackers
    }
}
