//
//  AddHabitViewControllerDelegate.swift
//  Tracker
//
//  Created by Николай Жирнов on 14.04.2025.
//

import Foundation

protocol AddHabitViewControllerDelegate: AnyObject {
    func reloadData(newSchedule: Set<WeekDay>)
}
