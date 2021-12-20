//
//  FeedPresenter.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import Foundation

protocol FeedPresenter {
    var postsCount: Int { get }
    func getPostForCell(by index: Int) -> PostCellModel
    func switchPreviewState(by index: Int)
    func viewDidLoad()
    func showDetail(by index: Int)
    func showFilter()
    func searchPostForTitle(_ searchWord: String)
    func breakSearch()
    func logOut()
}

final class FeedPresenterImplementation {
    
    weak var view: FeedViewControllerProtocol?
    
    // MARK: - Private properties -
    
    private let service: NetworkService
    private let router: FeedRouter
    
    private var searchTask: DispatchWorkItem?
    
    private var searchText = ""
    
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
    
    init(view: FeedViewControllerProtocol, service: NetworkService, router: FeedRouter) {
        self.service = service
        self.view = view
        self.router = router
    }
    
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
        case .none:
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

// MARK: - FeedPresenter -

extension FeedPresenterImplementation: FeedPresenter {
    func logOut() {
        KeychainService.shared.clear()
        router.showLoginScreen()
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
        view?.updateItemState(at: index)
    }
    
    func viewDidLoad() {
        service.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                self?.postList = data.posts.map(PostCellModel.init)
                self?.postsDefaultOrder = data.posts.map { $0.postId }
                self?.view?.updateView()
            case .failure(let error):
                switch error {
                case .offlined:
                    self?.view?.showNoInternetConnectionError()
                case .propagated:
                    self?.view?.showUnreachableServiceError()
                case .timeOut:
                    self?.view?.showNoInternetConnectionError()
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
            breakSearch()
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
    
    func breakSearch() {
        searchTask?.cancel()
        searchText = ""
        dataSource = postList
        view?.updateView()
    }
}

// MARK: - VC delegate -

extension FeedPresenterImplementation: FilterViewControllerDelegate {
    func onSortOptionChanged(_ option: FilterViewController.SortOption) {
        selectedSortOption = option
        view?.updateView()
    }
}

extension Date {
    static func stringFromInt(timestamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let time = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return formatter.string(from: time)
    }
}
