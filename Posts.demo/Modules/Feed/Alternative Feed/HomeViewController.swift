//
//  HomeViewController.swift
//  Posts.demo
//
//  Created by devmac on 08.12.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    var presenter: FeedPresenter!
    
    // MARK: - Private variables -
    
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
    
    @objc private func logOutButtonTapped() {
        presenter.logOut()
    }
    
    private lazy var collectionView: UICollectionView = {
        let horizontalInset: CGFloat = 16
        let verticalInset: CGFloat = 16
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: verticalInset,
                                               left: horizontalInset,
                                               bottom: verticalInset,
                                               right: horizontalInset)
        let insetsSum = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let widthForItem: CGFloat = view.bounds.width - insetsSum
        flowLayout.estimatedItemSize = CGSize(
            width: widthForItem,
            height: 200
        )
        
        flowLayout.minimumLineSpacing = 15
        let collection = UICollectionView(frame: self.view.bounds,
                                          collectionViewLayout: flowLayout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(CollectionViewCell.self,
                            forCellWithReuseIdentifier: "CollectionCell")
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
        title.font = UIFont(name: "Helvetica Neue", size: 20)
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
        searchBar.isHidden = presenter.postsCount == 0
        return searchBar
    }()
    
    @objc private func sortButtonTapped() {
        guard presenter.postsCount > 0 else { return }
        presenter.showFilter()
    }
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Private functions -
    
    private func initialSetup() {
        setupMainView()
        setupNavigationBar()
        setupSearchBarConstraints()
        configureCollectionView()
        layoutGradientView()
        presenter.viewDidLoad()
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
        let noResultImageView = UIImageView()
        noResultImageView.translatesAutoresizingMaskIntoConstraints = false
        guard let image = UIImage(named: "noItemsFound") else {
            return nil
        }
        let aspectRatio = image.size.width / image.size.height
        noResultImageView.frame.size = CGSize(width: (view.frame.size.width) / 2,
                                              height: (view.frame.size.width / aspectRatio) / 2)
        noResultImageView.image = image
        let containerNoResultView = UIView(frame: collectionView.bounds)
        noResultImageView.center = containerNoResultView.center
        containerNoResultView.translatesAutoresizingMaskIntoConstraints = false
        containerNoResultView.addSubview(noResultImageView)
        return containerNoResultView
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
    
    private func startSearching(with searchText: String) {
        presenter.searchPostForTitle(searchText)
    }
}

// MARK: - CollectionView extensions -

extension HomeViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.postsCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        if let postState = presenter.getPostForCell(by: indexPath.row) {
            cell.configure(postState: postState)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter.showDetail(by: indexPath.row)
    }
}

// MARK: - HomeViewController extensions -

extension HomeViewController: CollectionViewCellDelegate {
    func compressDescriptionLabel(_ cell: CollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter.switchPreviewState(by: indexPath.row)
    }
}

extension HomeViewController: FeedViewControllerProtocol {
    func showNoInternetConnectionError() {
        //
    }
    
    func showUnreachableServiceError() {
        //
    }
    
    func updateRowState(at index: Int) {
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: [IndexPath(item: index,
                                                      section: .zero)])
        }, completion: nil)
    }
    
    func updateView() {
        DispatchQueue.main.async { [unowned self] in
            self.collectionView.reloadData()
        }
    }
    
    func setupNoResultsViewIfNeeded(isResultsEmpty: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.backgroundView = isResultsEmpty ? self?.setupCollectionViewBackground() : nil
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
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
