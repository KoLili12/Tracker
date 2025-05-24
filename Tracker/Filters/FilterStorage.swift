//
//  FilterStorage.swift
//  Tracker
//
//  Created by Николай Жирнов on 21.05.2025.
//

import Foundation

final class FilterStorage {
    // MARK: - Singleton
    
    static let shared = FilterStorage()
    
    // MARK: - Constants
    
    private enum Constants {
        static let selectedFilterKey = "selectedTrackerFilter"
    }
    
    // MARK: - Private properties
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Public methods
    
    /// Получение текущего выбранного фильтра
    /// Если фильтр не задан ранее, возвращает nil
    func getSelectedFilter() -> String? {
        return userDefaults.string(forKey: Constants.selectedFilterKey)
    }
    
    /// Сохранение выбранного фильтра
    func saveSelectedFilter(_ filter: String) {
        userDefaults.set(filter, forKey: Constants.selectedFilterKey)
    }
    
    /// Сброс выбранного фильтра
    func resetSelectedFilter() {
        userDefaults.removeObject(forKey: Constants.selectedFilterKey)
    }
    
    // MARK: - Initializers
    
    private init() {}
}
