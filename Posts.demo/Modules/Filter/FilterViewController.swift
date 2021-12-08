//
//  FIlterViewController.swift
//  Posts.demo
//
//  Created by New Mac on 11.10.2021.
//

import UIKit

protocol FilterViewControllerDelegate: class {
    func onSortOptionChanged(_ option: FilterViewController.SortOption)
}

class FilterViewController: UIViewController {
    
    var presenter: FilterPresenter!
    
    // MARK: - Outlets
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


// MARK: - SortOption Definition


extension FilterViewController {
    enum SortOption {
        case dateAscending
        case dateDescending
        case popularityAscending
        case popularityDescending
        case none
    }
}
