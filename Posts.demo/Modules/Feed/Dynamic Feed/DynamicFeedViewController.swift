//
//  DynamicFeedViewController.swift
//  Posts.demo
//
//  Created by devmac on 24.12.2021.
//

import UIKit

protocol DynamicFeedViewControllerProtocol: FeedViewControllerProtocol {
    func setDisplayMode(_ mode: FeedDisplayMode)
    func updateCollectionItemState(at index: Int)
    func updateTableItemState(at index: Int)
}

class DynamicFeedViewController: UIViewController {
    var presenter: FeedPresenter!
    
    // MARK: - Private properties -
    
    private let gridLayout = GridLayout()
    private let galleryLayout = GalleryFlowLayout()
    
    private lazy var logOutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logOutButtonTapped)
        )
        button.tintColor = .white
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .red
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.view.bounds,
                                          collectionViewLayout: galleryLayout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        CollectionCell.register(in: collection)
        ShortCollectionCell.register(in: collection)
        
        collection.keyboardDismissMode = .interactive
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var bottomGradientView: UIView = {
        let view = UIView(frame: CGRect(x: .zero,
                                        y: .zero,
                                        width: view.bounds.width,
                                        height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.makeGradient(colors: [UIColor.clear,
                                   UIColor.black.withAlphaComponent(0.016),
                                   UIColor.black.withAlphaComponent(0.03125),
                                   UIColor.black.withAlphaComponent(0.0625),
                                   UIColor.black.withAlphaComponent(0.125),
                                   UIColor.black.withAlphaComponent(0.25),
                                   UIColor.black.withAlphaComponent(0.45)
                                  ])
        return view
    }()
    
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
        button.tintColor = .white
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.barTintColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.isTranslucent = true
        searchBar.placeholder = "Enter title"
        return searchBar
    }()
    
    private lazy var customTabView: CustomTabBar = {
        let itemSize = CGSize(width: UIScreen.main.bounds.width / 3,
                              height: 60)
        let view = CustomTabBar(
            items: presenter.displayModeOptionNames,
            with: itemSize)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - Private methods -
    
    private func initialSetup() {
        setupMainView()
        setupNavigationBar()
        setupSearchBarConstraints()
        setupConstraints()
        configureTableView()
        layoutGradientView()
        presenter.viewDidLoad()
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        PostCell.registerNib(in: tableView)
        tableView.keyboardDismissMode = .interactive
    }
    
    private func setupMainView() {
        self.view.backgroundColor = .lightGray
    }
    
    private func layoutGradientView() {
        view.addSubview(bottomGradientView)
        
        NSLayoutConstraint.activate([
            bottomGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomGradientView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupCollectionViewBackground() -> UIView? {
        guard let image = UIImage(named: "noItemsFound") else {
            return nil
        }
        let noResultImageView = UIImageView()

        let aspectRatio = image.size.width / image.size.height
        noResultImageView.frame.size = CGSize(
            width: (view.frame.size.width) / 2,
            height: (view.frame.size.width / aspectRatio) / 2
        )
        noResultImageView.image = image
        let containerNoResultView = UIView(frame: collectionView.bounds)
        noResultImageView.center = containerNoResultView.center
        containerNoResultView.addSubview(noResultImageView)
        return containerNoResultView
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(customTabView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: customTabView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            customTabView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            customTabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabView.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: customTabView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupSearchBarConstraints() {
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = logOutButton
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func search(for searchText: String) {
        presenter.searchPostForTitle(searchText)
    }
    
    // MARK: - Actions -
    
    @objc private func logOutButtonTapped() {
        presenter.logOut()
    }
    
    @objc private func sortButtonTapped() {
        guard presenter.postsCount > 0 else { return }
        presenter.showFilter()
    }
}

// MARK: - CollectionView Delegate -

extension DynamicFeedViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.postsCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch presenter.currentDisplayMode {
        case .grid:
            let cell = ShortCollectionCell.cell(in: collectionView,
                                                for: indexPath)
            let postState = presenter.getPostForCell(by: indexPath.row)
            cell.configure(postState: postState)
            return cell
        default:
            let cell = CollectionCell.cell(in: collectionView, for: indexPath)
            let postState = presenter.getPostForCell(by: indexPath.row)
            cell.configure(postState: postState)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter.showDetail(by: indexPath.row)
    }
}

// MARK: - TableView Delegate -

extension DynamicFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        presenter.postsCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostCell.cell(in: tableView, for: indexPath)
        cell.delegate = self
        let postState = presenter.getPostForCell(by: indexPath.row)
        cell.configure(postState: postState)
        return cell
    }

    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        presenter.showDetail(by: indexPath.row)
    }
}

// MARK: - CollectionCell Delegate -

extension DynamicFeedViewController: CollectionCellDelegate {
    func compressDescriptionLabel(_ cell: CollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter.switchPreviewState(by: indexPath.row)
    }
}

// MARK: - FeedViewControllerProtocol -

extension DynamicFeedViewController: DynamicFeedViewControllerProtocol {
    func updateCollectionItemState(at index: Int) {
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: [IndexPath(item: index,
                                                      section: .zero)])
        }, completion: nil)
    }
    
    func updateTableItemState(at index: Int) {
        tableView.performBatchUpdates({
            tableView.reloadRows(at: [IndexPath(item: index,
                                                section: .zero)], with: .fade)
        }, completion: nil)
    }
    

    func showNoInternetConnectionError() {}
    
    func showUnreachableServiceError() {}
    
    private func reloadCollection() {
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(.zero, animated: true)
    }
    
    func updateView() {
        DispatchQueue.main.async { [unowned self] in
            reloadCollection()
            self.tableView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func setupNoResultsViewIfNeeded(isResultsEmpty: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.backgroundView = isResultsEmpty ? self?.setupCollectionViewBackground() : nil
        }
    }
    
    func setDisplayMode(_ mode: FeedDisplayMode) {
        switch mode {
        case .list:
            tableView.isHidden = false
            collectionView.isHidden = true
        case .grid, .gallery:
            tableView.isHidden = true
            collectionView.isHidden = false
            collectionView.collectionViewLayout =
                (mode == .grid ? gridLayout : galleryLayout)
            reloadCollection()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: - SearchBarDelegate -

extension DynamicFeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        search(for: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

// MARK: - PostCellDelegate -

extension DynamicFeedViewController: PostCellDelegate {
    func compressDescriptionLabel(_ cell: PostCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        presenter.switchPreviewState(by: indexPath.row)
    }
}

// MARK: - CustomPageMenuDelegate -

extension DynamicFeedViewController: CustomTabBarDelegate {
    func menuItemSelected(at index: Int) {
        presenter.changeDisplayMode(index: index)
    }
}
