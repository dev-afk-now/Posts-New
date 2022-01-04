//
//  FeedRouter.swift
//  Posts.demo
//
//  Created by New Mac on 11.10.2021.
//

import UIKit

protocol FeedRouter {
    func showFilterScreen(_ delegate: FilterViewControllerDelegate)
    func showDetailScreen(id: Int)
    func showLoginScreen()
}

final class FeedRouterImplementation {
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension FeedRouterImplementation: FeedRouter {
    func showLoginScreen() {
        let module = SignUpConfigurator.create()
        UIViewController.swapCurrentViewController(with: module,
                                                   isReversed: true)
    }
    func showFilterScreen(_ delegate: FilterViewControllerDelegate) {
        let module = FilterConfigurator.create(delegate: delegate)
        context.modalPresentationStyle = .fullScreen
        context.navigationController?.present(module,
                                              animated: true,
                                              completion: nil)
    }
    
    func showDetailScreen(id: Int) {
        let module = DetailConfigurator.create(postId: id)
        context.navigationController?.pushViewController(module, animated: true)
    }
}

