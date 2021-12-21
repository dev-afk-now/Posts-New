//
//  PostsRepository.swift
//  Posts.demo
//
//  Created by devmac on 17.12.2021.
//

import Foundation

protocol PostsRepository {
    func getPosts(completion: @escaping(Result<[PostCellModel], NetworkServiceImplementation.Error>) -> Void)
}

class PostsRepositoryImplementation {
    
    enum Error: Swift.Error {
        case propagated(Swift.Error)
        case offlined
        case timeOut
    }
    
    private let service: NetworkService
    
    private var listPath = URL(string: "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/main.json")
    
    init(service: NetworkService) {
        self.service = service
    }
}

extension PostsRepositoryImplementation: PostsRepository {
    func getPosts(completion: @escaping (Result<[PostCellModel], NetworkServiceImplementation.Error>) -> Void) {
        service.fetchData(url: listPath!) { [weak self] (result: Result<NetworkPostList,
                                             NetworkServiceImplementation.Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                let posts = success.posts.map(PostCellModel.init)
                let localPosts = posts.map{ $0.initPersistent() }
                PersistentService.shared.savePosts(localPosts)
                completion(.success(posts))
            case .failure(let failure):
                let list = self.fetchLocalPosts()
                if list.isEmpty {
                    completion(.failure(failure))
                } else {
                    completion(.failure(failure))
                }
            }
        }
    }
    
    private func fetchLocalPosts() -> [PostPersistent] {
        return PersistentService.shared.fetchObjects(entity: PostPersistent.self)
    }
}
