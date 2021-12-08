//
//  FilterPresenter.swift
//  Posts.demo
//
//  Created by New Mac on 18.10.2021.
//

import Foundation

protocol FilterPresenter {
    func onSortOptionChosen(_ option: FilterViewController.SortOption?)
    func navigateBackCliked()
}

final class FilterPresenterImplementation {
    weak var delegate: FilterViewControllerDelegate?
    private let router: FilterRouter
    
    init(delegate: FilterViewControllerDelegate, router: FilterRouter) {
        self.delegate = delegate
        self.router = router
    }
}
extension FilterPresenterImplementation: FilterPresenter {
    func navigateBackCliked() {
        router.navigateBackToRootViewController()
    }
    
    func onSortOptionChosen(_ option: FilterViewController.SortOption?) {
        delegate?.onSortOptionChanged(option!)
    }
}
