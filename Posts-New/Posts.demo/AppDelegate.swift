//
//  AppDelegate.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        setStartViewController()
        clearKeychainIfNeed()
        return true
    }
    
    private func setStartViewController() {
        if KeychainService.isUserLoggedIn {
            window?.rootViewController = FeedConfigurator.create()
        } else {
            window?.rootViewController = SignUpConfigurator.create()
        }
        window?.makeKeyAndVisible()
    }
    
    private var appWasLaunched: Bool {
        get {
            UserDefaults.standard.bool(forKey: "appWasLaunched")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "appWasLaunched")
        }
    }
    
    private func clearKeychainIfNeed() {
        if appWasLaunched {
            KeychainService.shared.clear()
        } else {
            appWasLaunched = true
        }
    }
}

