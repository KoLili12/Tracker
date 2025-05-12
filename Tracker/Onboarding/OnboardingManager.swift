//
//  OnboardingManager.swift
//  Tracker
//
//  Created by Николай Жирнов on 12.05.2025.
//
import UIKit

class OnboardingManager {
    static let shared = OnboardingManager()
    
    // Ключ для хранения в UserDefaults
    private let wasOnboardingShownKey = "wasOnboardingShown"
    
    private init() {}
    
    var wasOnboardingShown: Bool {
        return UserDefaults.standard.bool(forKey: wasOnboardingShownKey)
    }
    
    func setOnboardingShown() {
        UserDefaults.standard.set(true, forKey: wasOnboardingShownKey)
    }
    
    // Сбрасывает статус стартового экрана (для отладки)
    func resetOnboardingStatus() {
        UserDefaults.standard.set(false, forKey: wasOnboardingShownKey)
    }
}
