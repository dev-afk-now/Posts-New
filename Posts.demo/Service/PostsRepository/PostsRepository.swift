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
            completion(.failure(.unresolved))
            return
        }
        service.fetchData(url: url) { (result: Result<NetworkPostList,
                                                         NetworkServiceImplementation.Error>) in
            switch result {
            case .success(let success):
                let posts = success.posts.map(PostCellModel.init)
                PostPersistentAdapter.shared.generateDatabasePostObjects(posts)
                completion(.success(posts))
            case .failure(let failure):
                let list = PostPersistentAdapter.shared.pullDatabasePostObjects()
                let posts: [PostCellModel] = list.map { PostCellModel(from: $0) }
                if list.isEmpty {
                    completion(.failure(failure))
                } else {
                    completion(.success(posts))
                }
            }
        }
    }
}
