//
//  DetailPresenter.swift
//  Posts.demo
//
//  Created by New Mac on 12.10.2021.
//

import UIKit

protocol ViewItem {}
struct TitleItem: ViewItem {
    let title: String
}
struct TextItem: ViewItem {
    let text: String
}
struct ImageItem: ViewItem {
    let image: URL?
}
struct DetailItem: ViewItem {
    let likes: Int
    let date: Date
}

protocol DetailPresenter {
    func viewDidLoad()
    func navigateToRootViewController()
}

final class DetailPresenterImpementation {
    private var postId: Int
    private var url: URL? {
        URL(
            string: "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/posts/\(postId).json")
    }
    weak var view: DetailViewControllerProtocol?
    private var repository: DetailRepository
    private var router: DetailRouter
    private var imageService: ImageService
    
    init(postId: Int,
         view: DetailViewControllerProtocol,
         repository: DetailRepository,
         router: DetailRouter,
         imageService: ImageService) {
        self.postId = postId
        self.view = view
        self.repository = repository
        self.router = router
        self.imageService = imageService
    }
}

extension DetailPresenterImpementation: DetailPresenter {
    func navigateToRootViewController() {
        router.navigateToRootViewController()
    }
    
    func viewDidLoad() {
        fetchPost()
    }
    
    private func fetchPost() {
        repository.getDetail { [weak self] result in
            switch result {
            case .success(let data):
                self?.createViewItems(from: data)
            case .failure(let error):
                switch error {
                case .offlined:
                    self?.view?.showNoInternetConnectionError()
                case .timeOut:
                    self?.view?.showTimeOutConnectionError()
                case .propagated:
                    self?.view?.showUnreachableServiceError()
                }
            }
        }
    }
    
    private func createViewItems(from post: DetailModel) {
        var items: [ViewItem] = []
        items.append(TitleItem(title: post.title))
        items.append(TextItem(text: post.text))
        self.imageService.fetchImages(post.images.map { URL(string: $0) }) { [weak self] (urls) in
            urls.forEach{
                items.append(ImageItem(image: $0))
            }
            items.append(DetailItem(likes: post.likesCount, date: post.date))
            DispatchQueue.main.async {
                self?.view?.updateView(items: items)
            }
        }
    }
}
