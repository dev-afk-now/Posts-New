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
        let localPosts = PersistentService.shared.fetchObjects(entity: PostPersistent.self)
            service.fetchData(url: listPath!) { (result: Result<NetworkPostList, NetworkServiceImplementation.Error>) in
                switch result {
                case .success(let success):
                    let posts = success.posts.map(PostCellModel.init)
                    let localPosts = posts.map{ $0.initPersistent() }
                    PersistentService.shared.savePosts(localPosts)
                    completion(.success(posts))
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
            return
        
        let postsForCell = localPosts.map{ PostCellModel.init(from: $0) }
        completion(.success(postsForCell))
    }
}
