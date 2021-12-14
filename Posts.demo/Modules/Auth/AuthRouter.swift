//
//  AuthRouter.swift
//  Posts.demo
//
//  Created by devmac on 14.12.2021.
//

import UIKit

protocol AuthRouter: AnyObject {
    func showFeed()
}

final class AuthRouterImplementation {
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension AuthRouterImplementation: AuthRouter {
    func showFeed() {
        let module = FeedConfigurator.create()
        module.modalPresentationStyle = .overFullScreen
        context.navigationController?.present(module, animated: true, completion: nil)
    }
}
