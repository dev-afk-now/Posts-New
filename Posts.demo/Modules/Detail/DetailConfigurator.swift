//
//  DetailConfigurator.swift
//  Posts.demo
//
//  Created by New Mac on 12.10.2021.
//

import UIKit

final class DetailConfigurator {
    static func create(postId: Int) -> UIViewController {
        let view = DetailViewController()
        let networkRequest = NetworkRequestImplementation()
        let networkService = NetworkServiceImplementation(requestService: networkRequest)
        let repository = DetailRepositoryImplementation(postId: postId, service: networkService)
        let imageRequest = ImageRequestImplementation()
        let imageService = ImageServiceImplementation(requestService: imageRequest)
        let router = DetailRouterImplementation(context: view)
        let presenter = DetailPresenterImpementation(postId: postId,
                                                     view: view,
                                                     repository: repository,
                                                     router: router,
                                                     imageService: imageService)
        view.presenter = presenter
        return view
    }
}
