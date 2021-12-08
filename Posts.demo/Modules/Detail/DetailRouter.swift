//
//  DetailRouter.swift
//  Posts.demo
//
//  Created by New Mac on 19.10.2021.
//

import UIKit

protocol DetailRouter {
    func navigateToRootViewController()
}

final class DetailRouterImplementation {
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension DetailRouterImplementation: DetailRouter {
    func navigateToRootViewController() {
        context.navigationController?.popViewController(animated: true)
    }
}
