//
//  AppDelegate.swift
//  Tracker
//
//  Created by Николай Жирнов on 20.03.2025.
//

import UIKit
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var window: UIWindow?
        window = UIWindow()
        // Проверяем, был ли уже показан стартовый экран
        if OnboardingManager.shared.wasOnboardingShown {
            let mainVC = TabBarViewController()
            window?.rootViewController = mainVC
        } else {
            let onboardingVC = OnboardingViewController()
            window?.rootViewController = onboardingVC
        }
        window?.makeKeyAndVisible()
        
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "342f6eb6-fc22-4d30-a7c8-be2302888493") else {
            return true
        }
        
        YMMYandexMetrica.activate(with: configuration)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

