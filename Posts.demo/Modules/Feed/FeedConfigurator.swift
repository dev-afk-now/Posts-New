//
//  FeedConfigurator.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import UIKit


final class FeedConfigurator {
    
    fileprivate class BaseNavigationController: UINavigationController {
        
        override init(rootViewController: UIViewController) {
            super.init(rootViewController: rootViewController)
            configure()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            configure()
        }
        
        private func configure() {
            navigationBar.isTranslucent = false
            navigationBar.barTintColor = .black
        }
    }
    
    static func create() -> UIViewController {
        let view = HomeViewController()
        let networkRequest = NetworkRequestImplementation()
        let networkService = NetworkServiceImplementation(requestService: networkRequest)
        let router = FeedRouterImplementation(context: view)
        let presenter = FeedPresenterImplementation(view: view, service: networkService, router: router)
        view.presenter = presenter
        let navVC = BaseNavigationController(rootViewController: view)
        return navVC
    }
}
