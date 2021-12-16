//
//  AuthConfigurator.swift
//  Posts.demo
//
//  Created by devmac on 13.12.2021.
//

import UIKit

final class SignUpConfigurator {
    static func create() -> UIViewController {
        let view = SignUpViewController()
        let router = SignUpRouterImplementation(context: view)
        let presenter = SignUpPresenterImplementation(view: view, router: router)
        view.presenter = presenter
        let navVC = BaseNavigationController(rootViewController: view)
        return navVC
    }
}
