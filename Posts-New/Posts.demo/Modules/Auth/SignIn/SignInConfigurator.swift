//
//  SignInConfigurator.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import UIKit

final class SignInConfigurator {
    static func create() -> UIViewController {
        let view = SignInViewController()
        let router = SignInRouterImplementation(context: view)
        let presenter = SignInPresenterImplementation(view: view, router: router)
        view.presenter = presenter
        let navVC = BaseNavigationController(rootViewController: view)
        return navVC
    }
}
