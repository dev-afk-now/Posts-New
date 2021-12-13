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
        let presenter = AuthPresenterImplementation(view: view)
        view.presenter = presenter
        return view
    }
}
