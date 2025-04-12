//
//  CreateTrackerDelegate.swift
//  Tracker
//
//  Created by Николай Жирнов on 12.04.2025.
//

import Foundation

protocol CreateTrackerDelegate: AnyObject {
    func createTracker(tracker: Tracker, categoryName: String)
}
