//
//  FIlterViewController.swift
//  Posts.demo
//
//  Created by New Mac on 11.10.2021.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func onSortOptionChanged(_ option: FilterViewController.SortOption)
}

class FilterViewController: UIViewController {
    
    var presenter: FilterPresenter!
    
    // MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private methods -
    
    func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Actions -
    
    @IBAction func clickedDateAscending(_ sender: UIButton) {
        presenter.onSortOptionChosen(.dateAscending)
        presenter.navigateBackCliked()
    }
    
    @IBAction func clickedDateDescending(_ sender: UIButton) {
        presenter.onSortOptionChosen(.dateDescending)
        presenter.navigateBackCliked()
    }
    @IBAction func clickedPopularityAscending(_ sender: UIButton) {
        presenter.onSortOptionChosen(.popularityAscending)
        presenter.navigateBackCliked()
    }
    
    @IBAction func clickedPopularityDescending(_ sender: UIButton) {
        presenter.onSortOptionChosen(.popularityDescending)
        presenter.navigateBackCliked()
    }
    
    @IBAction func clickedDefault(_ sender: UIButton) {
        presenter.onSortOptionChosen(FilterViewController.SortOption.none)
        presenter.navigateBackCliked()
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        presenter.navigateBackCliked()
    }
}
