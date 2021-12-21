//
//  DetailConfigurator.swift
//  Posts.demo
//
//  Created by New Mac on 12.10.2021.
//

import UIKit

final class DetailConfigurator {
    static func create(id: Int) -> UIViewController {
        let view = DetailViewController()
        let networkRequest = NetworkRequestImplementation()
        let networkService = NetworkServiceImplementation(requestService: networkRequest)
        let imageRequest = ImageRequestImplementation()
        let imageService = ImageServiceImplementation(requestService: imageRequest)
        let router = DetailRouterImplementation(context: view)
        let presenter = DetailPresenterImpementation(id: id,
                                                     view: view,
                                                     networkService: networkService,
                                                     router: router,
                                                     imageService: imageService)
        view.presenter = presenter
        return view
    }
}
