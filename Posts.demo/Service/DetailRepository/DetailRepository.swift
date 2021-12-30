//
//  DetailRepository.swift
//  Posts.demo
//
//  Created by devmac on 23.12.2021.
//

import Foundation

protocol DetailRepository {
    func getDetail(completion: @escaping(Result<DetailModel, NetworkServiceImplementation.Error>) -> Void)
}

class DetailRepositoryImplementation {
    
    enum Error: Swift.Error {
        case propagated(Swift.Error)
        case offlined
        case timeOut
    }
    
    private var postId: Int
    
    private let service: NetworkService
    
    private lazy var listPath = URL(
        string: "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/posts/\(postId).json")
    
    init(postId: Int, service: NetworkService) {
        self.service = service
        self.postId = postId
    }
}

extension DetailRepositoryImplementation: DetailRepository {
    func getDetail(
        completion: @escaping (Result<DetailModel, NetworkServiceImplementation.Error>) -> Void)
    {
        guard let url = listPath else {
            completion(.failure(.offlined))
            return
        }
        service.fetchData(url: url) { [weak self] (result: Result<NetworkDetail,
                                                         NetworkServiceImplementation.Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let postModel = DetailModel.init(data.post)
                postModel.generateDatabaseModel()
                PersistentService.shared.save()
                completion(.success(postModel))
            case .failure(let failure):
                let localDetail = self.fetchLocalDetail(by: self.postId)
                if let localDetail = localDetail {
                    let detail = DetailModel(from: localDetail)
                    completion(.success(detail))
                } else {
                    completion(.failure(failure))
                }
            }
        }
    }
    
    private func fetchLocalDetail(by postId: Int) -> DetailPersistentModel? {
        let details = PersistentService.shared.fetchObjects(entity: DetailPersistentModel.self)
        return details.first { $0.postId == postId }
    }
}
