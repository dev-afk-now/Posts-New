//
//  AuthRouter.swift
//  Posts.demo
//
//  Created by devmac on 14.12.2021.
//

import UIKit

protocol SignUpRouter: AnyObject {
    func showFeed()
    func showLogin()
    func showTermsOfService()
}

final class SignUpRouterImplementation {
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension SignUpRouterImplementation: SignUpRouter {
    func showLogin() {
        let module = SignInConfigurator.create()
        module.modalPresentationStyle = .overFullScreen
        module.modalTransitionStyle = .flipHorizontal
        context.present(module,
                        animated: true,
                        completion: nil)
    }
    
    func showTermsOfService() {
        let module = WebConfigurator.create()
        context.navigationController?.pushViewController(module,
                                                         animated: true)
    }
    
    func showFeed() {
        let module = FeedConfigurator.create()
        UIViewController.swapCurrentViewController(with: module)
    }
}
