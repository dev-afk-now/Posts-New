//
//  DetailPresenter.swift
//  Posts.demo
//
//  Created by New Mac on 12.10.2021.
//

import UIKit

protocol DetailPresenter {
    func viewDidLoad()
    func navigateToRootViewController()
}

final class DetailPresenterImpementation {
    private var id: Int
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
        networkService.fetchPost(by: id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.createViewItems(from: data.post)
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
    private func createViewItems(from post: ConcretePost){
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
    
    private func fetchImage(url: URL?, completion: @escaping(UIImage) -> Void) {
        imageService.fetchImage(url) { url in
            if url != nil {
                guard let data = try? Data(contentsOf: url!),
                      let image = UIImage(data: data) else { return }
                completion(image)
            }
        }
    }
}


