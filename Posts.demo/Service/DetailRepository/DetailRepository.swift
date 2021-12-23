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
    
    private var id: Int
    
    private let service: NetworkService
    
    private lazy var listPath = URL(
        string: "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/posts/\(id).json")
    
    init(id: Int, service: NetworkService) {
        self.service = service
        self.id = id
    }
}

extension DetailRepositoryImplementation: DetailRepository {
    func getDetail(
        completion: @escaping (Result<DetailModel, NetworkServiceImplementation.Error>) -> Void)
    {
        service.fetchData(url: listPath!) { [weak self] (result: Result<NetworkDetail,
                                                         NetworkServiceImplementation.Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                let postModel = DetailModel.init(success.post)
                postModel.initPersistent()
                PersistentService.shared.save()
                completion(.success(postModel))
            case .failure(let failure):
                let localDetail = self.fetchLocalDetail(by: self.id)
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
