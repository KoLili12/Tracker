//
//  TrackerUpdateDelegate.swift
//  Tracker
//
//  Created by Николай Жирнов on 28.04.2025.
//

import Foundation

protocol TrackerUpdateDelegate: AnyObject {
    func updateCollection(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate)
}
