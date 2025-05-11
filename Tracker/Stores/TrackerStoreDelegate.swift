//
//  TrackerStoreDelegate.swift
//  Tracker
//
//  Created by Николай Жирнов on 28.04.2025.
//

import Foundation

protocol TrackerStoreDelegate: AnyObject {
    func store(
        _ store: TrackerStore,
        didUpdate update: TrackerStoreUpdate
    )
    
    func updateFullCollection()
}
