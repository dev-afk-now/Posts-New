//
//  FeedConfigurator.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import UIKit


final class FeedConfigurator {
    static func create() -> UIViewController {
        let view = FeedViewController()
        let networkRequest = NetworkRequestImplementation()
        let networkService = NetworkServiceImplementation(requestService: networkRequest)
        let router = FeedRouterImplementation(context: view)
        let presenter = FeedPresenterImplementation(view: view, service: networkService, router: router)
        view.presenter = presenter
        let navVC = BaseNavigationController(rootViewController: view)
        return navVC
    }
}
