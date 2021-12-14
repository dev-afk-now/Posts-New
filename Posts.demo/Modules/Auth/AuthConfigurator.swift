//
//  AuthConfigurator.swift
//  Posts.demo
//
//  Created by devmac on 13.12.2021.
//

import UIKit

final class AuthConfigurator {
    static func create() -> UIViewController {
        let view = AuthViewController()
        let router = AuthRouterImplementation(context: view)
        let presenter = AuthPresenterImplementation(view: view, router: router)
        view.presenter = presenter
        let navVC = BaseNavigationController(rootViewController: view)
        return navVC
    }
}
