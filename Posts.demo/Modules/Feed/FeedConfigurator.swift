//
//  FeedConfigurator.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import UIKit


final class FeedConfigurator {
    static func create() -> UIViewController {
        let view = DynamicFeedViewController()
        let networkRequest = NetworkRequestImplementation()
        let networkService = NetworkServiceImplementation(requestService: networkRequest)
        let repository = PostsRepositoryImplementation(service: networkService)
        let router = FeedRouterImplementation(context: view)
        let presenter = FeedPresenterImplementation(view: view,
                                                    repository: repository,
                                                    router: router)
        view.presenter = presenter
        let navVC = BaseNavigationController(rootViewController: view)
        return navVC
    }
}
