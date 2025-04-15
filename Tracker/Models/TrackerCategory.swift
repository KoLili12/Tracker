//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Николай Жирнов on 29.03.2025.
//

import Foundation

struct TrackerCategory {
    let id: UUID = UUID()
    let header: String
    let trackers: [Tracker]
}
