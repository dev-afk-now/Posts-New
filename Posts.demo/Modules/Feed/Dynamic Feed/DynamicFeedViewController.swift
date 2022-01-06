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
    private var galleryLayout = GalleryFlowLayout()
    
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
    
    private lazy var displayModeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "rectangle.on.rectangle"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(openModeSelector))
        button.tintColor = .white
        return button
    }()
    
    private lazy var mockPickerTextField: UITextField = {
        let field = UITextField()
        return field
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
    
    private lazy var pickerView: UIPickerView = {
        var picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        var toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()


        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(doneModeSelector))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelModeSelector))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true

        mockPickerTextField.inputView = picker
        mockPickerTextField.inputAccessoryView = toolBar
        return picker
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
        view.addSubview(pickerView)
        view.addSubview(mockPickerTextField)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
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
        navigationItem.leftBarButtonItems = [logOutButton, displayModeButton]
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func search(with searchText: String) {
        presenter.searchPostForTitle(searchText)
    }
    
    // MARK: - Actions -
    
    @objc private func cancelModeSelector() {
        mockPickerTextField.resignFirstResponder()
    }
    
    @objc private func doneModeSelector() {
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        presenter.changeDisplayMode(index: selectedIndex)
        mockPickerTextField.resignFirstResponder()
    }
    
    @objc private func openModeSelector() {
        mockPickerTextField.becomeFirstResponder()
    }
    
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
        switch presenter.displayMode {
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
    
    func updateView() {
        DispatchQueue.main.async { [unowned self] in
            self.collectionView.reloadData()
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
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: - SearchBarDelegate -

extension DynamicFeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        search(with: searchText)
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

// MARK: - PickerView Delegate -

extension DynamicFeedViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return FeedDisplayMode.allCases.count
    }
}

extension DynamicFeedViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        String(describing: FeedDisplayMode.allCases[row])
    }
}
