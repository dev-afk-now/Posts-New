//
//  SignInRouter.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import UIKit


protocol SignInRouter: AnyObject {
    func changeFlow()
    func showRegistration()
}

final class SignInRouterImplementation {
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension SignInRouterImplementation: SignInRouter {
    func changeFlow() {
        let module = FeedConfigurator.create()
        UIViewController.swapCurrentViewController(with: module)
    }
    
    func showRegistration() {
        context.dismiss(animated: true, completion: nil)
    }
}
