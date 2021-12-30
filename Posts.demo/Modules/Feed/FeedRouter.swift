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
}

final class FeedRouterImplementation {
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension FeedRouterImplementation: FeedRouter {
    func showFilterScreen(_ delegate: FilterViewControllerDelegate) {
        let filterVC = FilterConfigurator.create(delegate: delegate)
        context.present(filterVC, animated: true)
    }
    
    func showDetailScreen(id: Int) {
        let module = DetailConfigurator.create(postId: id)
        context.navigationController?.pushViewController(module, animated: true)
    }
}
