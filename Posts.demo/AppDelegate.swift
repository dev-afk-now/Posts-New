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
        let view = FeedConfigurator.create()
        window?.rootViewController = view
        window?.makeKeyAndVisible()
        return true
    }
}

