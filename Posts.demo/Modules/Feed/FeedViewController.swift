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
    func updateItemState(at index: Int)
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
        let title = UILabel()
        title.textColor = .white
        title.font = .applicatonFont(size: 20)
        title.text = "Главная"
        return title
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "component"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        return button
    }()
    
    @objc private func sortButtonTapped() {
        guard presenter.postsCount > 0 else { return }
        presenter.showFilter()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        presenter.viewDidLoad()
        setupNavigationBar()
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
        tableView.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: "TableCell")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.delegate = self
        let postState = presenter.getPostForCell(by: indexPath.row) 
            cell.configure(postState: postState)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetail(by: indexPath.row)
    }
}

// MARK: - FeedViewController extensions

extension FeedViewController: TableViewCellDelegate {
    func compressDescriptionLabel(_ cell: TableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.switchPreviewState(by: indexPath.row)
    }
}

extension FeedViewController: FeedViewControllerProtocol {
    func updateItemState(at index: Int) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: index,
                                            section: .zero)],
                             with: .automatic)
        tableView.endUpdates()
    }
    
    func showNoInternetConnectionError() {
        setUpViewsForError(text: "No Internet Connection", alertBackground: .lightGray)
    }
    
    func showUnreachableServiceError() {
        setUpViewsForError()
    }
    
    private func setUpViewsForError(text: String = "Something went wrong",
                                    alertBackground: UIColor = .red) {
        DispatchQueue.main.async { [unowned self] in
            progressView.stopAnimating()
            alertView.backgroundColor = alertBackground
            failDescriptionLabel.text = text
            alertView.isHidden = false
        }
    }
    
    func updateView() {
        DispatchQueue.main.async { [unowned self] in
            self.progressView.stopAnimating()
            self.alertView.isHidden = true
            self.tableView.reloadData()
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
