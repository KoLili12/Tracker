//
//  FiltertsViewControllerDelegate.swift
//  Tracker
//
//  Created by Николай Жирнов on 21.05.2025.
//

import Foundation

protocol FiltersViewControllerDelegate: AnyObject {
    func filtersTrackersDidChange(filter: TrackerFilter?)
}
