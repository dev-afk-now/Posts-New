//
//  WebRouter.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import UIKit

protocol WebRouter {
    func navigateBackToRootViewController()
}

class WebRouterImplementation {
    
    unowned let context: UIViewController!
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension WebRouterImplementation: WebRouter {
    func navigateBackToRootViewController() {
        context.navigationController?.popViewController(animated: true)
    }
}
