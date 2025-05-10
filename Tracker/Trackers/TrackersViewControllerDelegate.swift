//
//  TrackersViewControllerDelegate.swift
//  Tracker
//
//  Created by Николай Жирнов on 09.04.2025.
//

import Foundation

protocol TrackersViewControllerDelegate: AnyObject {
    func updateDaysCount(cell: TrackerCollectionViewCell)
}
