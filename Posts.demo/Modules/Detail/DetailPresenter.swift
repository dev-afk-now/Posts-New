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
    private var id: Int
    private lazy var url = URL(string: "https://raw.githubusercontent.com/ aShaforostov/jsons/master/api/posts/\(id).json")
    weak var view: DetailViewControllerProtocol?
    private var networkService: NetworkService
    private var router: DetailRouter
    private var imageService: ImageService
    
    init(id: Int, view: DetailViewControllerProtocol, networkService: NetworkService, router: DetailRouter, imageService: ImageService) {
        self.id = id
        self.view = view
        self.networkService = networkService
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
        networkService.fetchData(url: url!) { (result: Result<NetworkDetail, NetworkServiceImplementation.Error>) in
            switch result {
            case .success(let data):
                self.createViewItems(from: data.post)
            case .failure(let error):
                switch error {
                case .offlined:
                    self.view?.showNoInternetConnectionError()
                case .timeOut:
                    self.view?.showTimeOutConnectionError()
                case .propagated:
                    self.view?.showUnreachableServiceError()
                }
            }
        }
    }
    private func createViewItems(from post: Detail){
        var items: [ViewItem] = []
        items.append(TitleItem(title: post.title))
        items.append(TextItem(text: post.text))
        self.imageService.fetchImages(post.images.map{ URL(string: $0) }) { [unowned self] (urls) in
            urls.forEach{
                items.append(ImageItem(image: $0))
            }
            items.append(DetailItem(likes: post.likes_count, date: post.date))
            DispatchQueue.main.async {
                view?.updateView(items: items)
            }
        }
    }
}


