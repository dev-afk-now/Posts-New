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
                let detailModel = DetailModel.init(from: data.post)
                DetailPersistentAdapter.shared.generateDatabaseDetailObject(from: detailModel)
                completion(.success(detailModel))
            case .failure(let failure):
                let localDetail = DetailPersistentAdapter.shared.pullDatabaseDetailObject(by: self.postId)
                guard let localDetail = localDetail else {
                    completion(.failure(failure))
                    return
                }
                let detail = DetailModel(from: localDetail)
                completion(.success(detail))
            }
        }
    }
}
