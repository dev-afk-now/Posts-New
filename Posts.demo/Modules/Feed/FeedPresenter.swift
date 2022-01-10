//
//  FeedPresenter.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import Foundation

protocol FeedPresenter {
    var postsCount: Int { get }
    var currentDisplayMode: FeedDisplayMode { get }
    var displayModeOptionCount: Int { get }
    var displayModeOptionNames: [String] { get }
    func getPostForCell(by index: Int) -> PostCellModel
    func switchPreviewState(by index: Int)
    func viewDidLoad()
    func showDetail(by index: Int)
    func showFilter()
    func searchPostForTitle(_ searchWord: String)
    func logOut()
    func changeDisplayMode(index: Int)
}

final class FeedPresenterImplementation {
    
    weak var view: DynamicFeedViewControllerProtocol?
    
    // MARK: - Private properties -
    
    private let repository: PostsRepository
    private let router: FeedRouter
    
    private var listPath: URL? {
        URL(string: "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/main.json")
    }
    
    private var searchTask: DispatchWorkItem?
    
    private var searchText = ""
    private var viewDisplayMode: FeedDisplayMode = .list
    
    private var isSearchingForPost: Bool {
        !searchText.isEmpty
    }
    
    private var postList: [PostCellModel] = []
    private var searchResults: [PostCellModel] = []
    private var dataSource: [PostCellModel] {
        get {
            var list = isSearchingForPost ? searchResults : postList
            list = sortedItems(list, by: selectedSortOption)
            return list
        }
        set {
            if isSearchingForPost {
                searchResults = newValue
            } else {
                postList = newValue
            }
        }
    }
    private var postsDefaultOrder: [Int] = []
    private var selectedSortOption: FilterViewController.SortOption = .none
    
    // MARK: - Lifecycle -
    
    init(view: DynamicFeedViewControllerProtocol, repository: PostsRepository, router: FeedRouter) {
        self.repository = repository
        self.view = view
        self.router = router
    }
    
    // MARK: - Private methods -
    private func sortedItems(_ items: [PostCellModel],
                             by option: FilterViewController.SortOption) -> [PostCellModel] {
        switch option {
        case .dateAscending:
            return items.sorted { $0.timestamp < $1.timestamp }
        case .dateDescending:
            return items.sorted { $0.timestamp > $1.timestamp }
        case .popularityAscending:
            return items.sorted { $0.likesCount < $1.likesCount }
        case .popularityDescending:
            return items.sorted { $0.likesCount > $1.likesCount }
        default:
            return setPostsOrderByDefault(items: items)
        }
    }
    
    private func setPostsOrderByDefault(items: [PostCellModel]) -> [PostCellModel] {
        var defaultArray = [PostCellModel]()
        for index in postsDefaultOrder {
            defaultArray += items.filter { $0.postId == index }
        }
        return defaultArray
    }
    
    
}

// MARK: - FeedPresenterImplementation extensions -

extension FeedPresenterImplementation: FeedPresenter {
    var displayModeOptionCount: Int {
        return FeedDisplayMode.allCases.count
    }
    
    var displayModeOptionNames: [String] {
        let arr =  FeedDisplayMode.allCases.map{
            String(describing: $0).capitalized
        }
        print(arr)
        return arr
    }
    
    var currentDisplayMode: FeedDisplayMode {
        return viewDisplayMode
    }
    
    func changeDisplayMode(index: Int) {
        let state = FeedDisplayMode.allCases[index]
        viewDisplayMode = state
        view?.setDisplayMode(state)
    }
    
    func logOut() {
        KeychainService.shared.clear()
        router.showRegistrationScreen()
    }
    
    func showDetail(by index: Int) {
        let post = getPostForCell(by: index)
        router.showDetailScreen(id: post.postId)
    }
    
    func showFilter() {
        router.showFilterScreen(self)
    }
    
    var postsCount: Int {
        self.dataSource.count
    }
    
    func getPostForCell(by index: Int) -> PostCellModel {
        return dataSource[index]
    }
    
    func switchPreviewState(by index: Int) {
        dataSource[index].isShowingFullPreview.toggle()
        switch viewDisplayMode {
        case .list:
            view?.updateTableItemState(at: index)
        case .grid, .gallery:
            view?.updateCollectionItemState(at: index)
        }
    }
    
    func viewDidLoad() {
        repository.getPosts { [weak self] result in
            switch result {
            case .success(let posts):
                self?.postsDefaultOrder = posts.map { $0.postId }
                self?.postList = posts
                self?.view?.updateView()
            case .failure(let error):
                switch error {
                case .offlined:
                    self?.view?.showNoInternetConnectionError()
                case .timeOut:
                    self?.view?.showNoInternetConnectionError()
                default:
                    self?.view?.showUnreachableServiceError()
                }
            }
        }
    }
    
    func searchPostForTitle(_ searchWord: String) {
        searchText = searchWord
        executeSearch()
    }
    
    private func executeSearch() {
        if searchText.isEmpty {
            breakSearch(of: searchTask)
            return
        }
        
        if searchText.count < 2 {
            return
        }
        
        searchTask?.cancel()
        let workItem = DispatchWorkItem { [unowned self] in
            self.searchResults = self.postList.filter{ $0.title.contains(self.searchText) }
            self.view?.updateView()
            self.view?.setupNoResultsViewIfNeeded(isResultsEmpty: self.searchResults.isEmpty)
        }
        searchTask = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: workItem)
    }
    
    private func breakSearch(of dispatchWorkItem: DispatchWorkItem?) {
        dispatchWorkItem?.cancel()
        searchText = ""
        dataSource = postList
        view?.updateView()
    }
}

// MARK: - FeedPresenterImplementation extension -

extension FeedPresenterImplementation: FilterViewControllerDelegate {
    func onSortOptionChanged(_ option: FilterViewController.SortOption) {
        selectedSortOption = option
        view?.updateView()
    }
}

// MARK: - FeedDisplayMode -

enum FeedDisplayMode: CaseIterable {
    case list
    case grid
    case gallery
}
