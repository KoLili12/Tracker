//
//  CreateTrackerDelegate.swift
//  Tracker
//
//  Created by Николай Жирнов on 12.04.2025.
//

import Foundation

protocol CreateTrackerDelegate: AnyObject {
    var service: TrackersServiceProtocol { get set }
    func createTracker(tracker: Tracker, categoryName: String)
}
