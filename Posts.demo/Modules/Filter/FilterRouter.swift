//
//  FilterRouter.swift
//  Posts.demo
//
//  Created by New Mac on 19.10.2021.
//

import UIKit

protocol FilterRouter {
    func navigateBackToRootViewController()
}

final class FilterRouterImplementation {
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension FilterRouterImplementation: FilterRouter {
    func navigateBackToRootViewController() {
        switch context {
        case let navigationController as UINavigationController:
            navigationController.popViewController(animated: true)
        default:
            context.dismiss(animated: true, completion: nil)
        }
    }
}
