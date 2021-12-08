//
//  FeedViewController.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import UIKit

protocol FeedViewControllerProtocol: AnyObject {
    func updateView()
    func showNoInternetConnectionError()
    func showUnreachableServiceError()
    func setupNoResultsViewIfNeeded(isResultsEmpty: Bool)
}

class FeedViewController: UIViewController {
    
    var presenter: FeedPresenter!
    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var progressView: UIActivityIndicatorView!
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var failDescriptionLabel: UILabel!
    
    @IBAction private func updateContentView(_ sender: Any) {
        alertView.isHidden = true
        presenter.viewDidLoad()
        progressView.startAnimating()
    }
    private lazy var titleLabel: UILabel = {
        $0.textColor = .white
        $0.font = UIFont(name: "Helvetica Neue", size: 20)
        $0.text = "Главная"
        return $0
    }(UILabel())
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "component"),
            style: .plain,
            target: self,
            action: #selector(sortAction)
        )
        button.tintColor = .white
        return button
    }()
    
    @objc private func sortAction() {
        guard presenter.postsCount > 0 else { return }
        presenter.showFilter()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureTableView()
        presenter.viewDidLoad()
    }
    
    private func setupTableViewBackground() -> UIView? {
        let noResultImageView = UIImageView()
        noResultImageView.translatesAutoresizingMaskIntoConstraints = false
        guard let image = UIImage(named: "noItemsFound") else {
            return nil
        }
        let aspectRatio = image.size.width / image.size.height
        noResultImageView.frame.size = CGSize(width: (view.frame.size.width)/2,
                                              height: (view.frame.size.width / aspectRatio)/2)
        noResultImageView.image = image
        let containerNoResultView = UIView(frame: tableView.bounds)
        noResultImageView.center = containerNoResultView.center
        containerNoResultView.translatesAutoresizingMaskIntoConstraints = false
        containerNoResultView.addSubview(noResultImageView)
        return containerNoResultView
    }
    
    private func configureTableView() {
        tableView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        tableView.contentSize = UIScreen.main.bounds.size
        tableView.keyboardDismissMode = .interactive
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func startSearching(with searchText: String) {
        presenter.searchPostForTitle(searchText)
    }
}

// MARK: - TableView extensions

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.postsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
        cell?.delegate = self
        if let postState = presenter.getPostForCell(by: indexPath.row) {
            cell?.configure(postState: postState)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetail(by: indexPath.row)
    }
}

// MARK: - FeedViewController extensions

extension FeedViewController: TableViewCellProtocol {
    func compressDescriptionLabel(_ cell: TableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.toggle(by: indexPath.row)
    }
}

extension FeedViewController: FeedViewControllerProtocol {
    func showNoInternetConnectionError() {
        setUpViewsForError(text: "No Internet Connection", alertBackground: .lightGray)
    }
    
    func showUnreachableServiceError() {
        setUpViewsForError()
    }
    
    private func setUpViewsForError(text: String = "Something went wrong", alertBackground: UIColor = .red) {
        DispatchQueue.main.async { [unowned self] in
            progressView.stopAnimating()
            alertView.backgroundColor = alertBackground
            failDescriptionLabel.text = text
            alertView.isHidden = false
        }
    }
    
    func updateView() {
        DispatchQueue.main.async { [unowned self] in
            self.alertView.isHidden = true
            self.tableView.reloadData()
            self.progressView.stopAnimating()
        }
    }
    
    func setupNoResultsViewIfNeeded(isResultsEmpty: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.backgroundView = isResultsEmpty ? self?.setupTableViewBackground() : nil
        }
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        startSearching(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        presenter.breakSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          view.endEditing(true)
    }
}
