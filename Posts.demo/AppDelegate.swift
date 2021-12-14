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
        window?.makeKeyAndVisible()
        
        let isFirstInstall = UserDefaults.standard.bool(forKey: "isFirstInstall")
        
        if !isFirstInstall {
            KeychainService.shared.clear()
            UserDefaults.standard.set(true, forKey: "isFirstInstall")
        }
        setStartViewController()
        
        return true
    }
    
    @objc private func notificationFunc() {
        print("Notification Works!!")
        setStartViewController()
    }
    
    private func setStartViewController() {
//         использовать кийчейн
        if KeychainService.isUserLoggedIn {
            window?.rootViewController = FeedConfigurator.create()
        } else {
            window?.rootViewController = AuthConfigurator.create()
        }
    }
}

