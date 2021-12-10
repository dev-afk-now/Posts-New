//
//  HomeViewController.swift
//  Posts.demo
//
//  Created by devmac on 08.12.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    var presenter: FeedPresenter!
    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private lazy var collectionView: UICollectionView = {
        let horizontalInset: CGFloat = 16
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        let insetsSum = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let widthForItem: CGFloat = view.bounds.width - insetsSum
        flowLayout.estimatedItemSize = CGSize(
            width: widthForItem,
            // Make the height a reasonable estimate to
            // ensure the scroll bar remains smooth
            height: 200
        )

        flowLayout.minimumLineSpacing = 15
        // TODO: - Flow layout must be configured here -
        let collection = UICollectionView(frame: self.view.bounds,
                                          collectionViewLayout: flowLayout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        collection.keyboardDismissMode = .interactive
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
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
            action: #selector(sortButtonTapped)
        )
        button.tintColor = .white
        return button
    }()
    
    @objc private func sortButtonTapped() {
        guard presenter.postsCount > 0 else { return }
        presenter.showFilter()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - Private -
    private func initialSetup() {
        setupMainView()
        setupNavigationBar()
        configureCollectionView()
        presenter.viewDidLoad()
    }
    
    private func setupMainView() {
        self.view.backgroundColor = .gray
    }
    
    private func setupCollectionViewBackground() -> UIView? {
        let noResultImageView = UIImageView()
        noResultImageView.translatesAutoresizingMaskIntoConstraints = false
        guard let image = UIImage(named: "noItemsFound") else {
            return nil
        }
        let aspectRatio = image.size.width / image.size.height
        noResultImageView.frame.size = CGSize(width: (view.frame.size.width)/2,
                                              height: (view.frame.size.width / aspectRatio)/2)
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
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func startSearching(with searchText: String) {
        presenter.searchPostForTitle(searchText)
    }
}

// MARK: - CollectionView extensions

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.postsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        if let postState = presenter.getPostForCell(by: indexPath.row) {
            cell.configure(postState: postState)
        }
        return cell
    }
}

// MARK: - FeedViewController extensions

extension HomeViewController: CollectionViewCellDelegate {
    func compressDescriptionLabel(_ cell: CollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter.switchPreviewState(by: indexPath.row)
    }
}

extension HomeViewController: FeedViewControllerProtocol {
    func updateRowState(at index: Int) {
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: [IndexPath(item: index,
                                                      section: .zero)])
        }, completion: nil)
    }
    
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
            // self.alertView.isHidden = true
            self.collectionView.reloadData()
            //self.progressView.stopAnimating()
        }
    }
    
    func setupNoResultsViewIfNeeded(isResultsEmpty: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.backgroundView = isResultsEmpty ? self?.setupCollectionViewBackground() : nil
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
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

