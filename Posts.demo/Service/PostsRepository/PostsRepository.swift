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
    
    private let listPath = URL(
        string: "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/main.json")
    
    init(service: NetworkService) {
        self.service = service
    }
}

extension PostsRepositoryImplementation: PostsRepository {
    func getPosts(completion: @escaping (Result<[PostCellModel], NetworkServiceImplementation.Error>) -> Void) {
        guard let url = listPath else {
            completion(.failure(.offlined))
            return
        }
        service.fetchData(url: url) { [weak self] (result: Result<NetworkPostList,
                                                         NetworkServiceImplementation.Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                let posts = success.posts.map(PostCellModel.init)
                let _ = posts.map{ $0.generateDatabaseModel() }
                PersistentService.shared.save()
                completion(.success(posts))
            case .failure(let failure):
                let list = self.fetchLocalPosts()
                let posts: [PostCellModel] = list.map { PostCellModel(from: $0) }
                if list.isEmpty {
                    completion(.failure(failure))
                } else {
                    completion(.success(posts))
                }
            }
        }
    }
    
    private func fetchLocalPosts() -> [PostPersistent] {
        return PersistentService.shared.fetchObjects(entity: PostPersistent.self)
    }
}
