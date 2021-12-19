//
//  FilterConfigurator.swift
//  Posts.demo
//
//  Created by New Mac on 18.10.2021.
//

import UIKit

final class FilterConfigurator {
    static func create(delegate: FilterViewControllerDelegate) -> UIViewController {
        let view = FilterViewController()
        let router = FilterRouterImplementation(context: view)
        let presenter = FilterPresenterImplementation(delegate: delegate, router: router)
        view.presenter = presenter
        return view
    }
}
