//
//  WebPresenter.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import Foundation

protocol WebPresenter: AnyObject {
    func backButtonClicked()
}

class WebPresenterImplementation {
    weak var view: WebViewControllerProtocol?
    private let router: WebRouter!
    
    init(view: WebViewControllerProtocol, router: WebRouter) {
        self.view = view
        self.router = router
    }
}

extension WebPresenterImplementation: WebPresenter {
    func backButtonClicked() {
        router.navigateBackToRootViewController()
    }
    
}
