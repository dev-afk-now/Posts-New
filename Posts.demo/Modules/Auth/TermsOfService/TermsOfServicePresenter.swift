//
//  WebPresenter.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import Foundation

protocol TermsOfServicePresenter: AnyObject {
    func backButtonClicked()
}

class TermsOfServicePresenterImplementation {
    weak var view: TermsOfServiceViewControllerEntity?
    private let router: TermsOfServiceRouter!
    
    init(view: TermsOfServiceViewControllerEntity, router: TermsOfServiceRouter) {
        self.view = view
        self.router = router
    }
}

extension TermsOfServicePresenterImplementation: TermsOfServicePresenter {
    func backButtonClicked() {
        router.navigateBackToRootViewController()
    }
    
}
