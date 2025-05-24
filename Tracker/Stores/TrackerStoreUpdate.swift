//
//  TrackerStoreUpdate.swift
//  Tracker
//
//  Created by Николай Жирнов on 28.04.2025.
//

import Foundation

struct TrackerStoreUpdate {
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
    let updatedIndexes: [IndexPath]
    let insertedSections: IndexSet
    let deletedSections: IndexSet
    let updatedSections: IndexSet  
}
