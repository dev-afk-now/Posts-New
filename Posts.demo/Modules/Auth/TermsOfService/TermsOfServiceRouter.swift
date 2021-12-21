//
//  WebRouter.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import Foundation
import UIKit

protocol TermsOfServiceRouter {
    func navigateBackToRootViewController()
}

class WebRouterImplementation {
    
    unowned let context: UIViewController!
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension WebRouterImplementation: TermsOfServiceRouter {
    func navigateBackToRootViewController() {
        context.navigationController?.popViewController(animated: true)
    }
}
