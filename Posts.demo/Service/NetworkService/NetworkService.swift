//
//  NetworkService.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import Foundation

protocol NetworkService {
    func fetchPost(by id: Int, completion: @escaping (Result<NetworkPost, NetworkServiceImplementation.Error>) -> Void)
    func fetchData(completion: @escaping (Result<NetworkData, NetworkServiceImplementation.Error>) -> Void)
}

final class NetworkServiceImplementation {
    
    enum Error: Swift.Error {
        case propagated(Swift.Error)
        case offlined
        case timeOut
    }
    
    private var listPath = "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/main.json"
    private var basicPath = "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/posts/[id].json"
    private var requestService: NetworkRequest!
    
    
    init(requestService: NetworkRequest) {
        self.requestService = requestService
    }
}

extension NetworkServiceImplementation: NetworkService {
    func fetchPost(by id: Int, completion: @escaping (Result<NetworkPost, NetworkServiceImplementation.Error>) -> Void) {
        if let url = URL(string: basicPath.replacingOccurrences(of: "[id]", with: "\(id)")) {
            requestService.GET(url: url) { (result: Result<NetworkPost, NetworkRequestImplementation.Error>) in
                switch result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    switch error {
                    case let .propagated(error):
                        let error = error as NSError
                        switch error.code {
                        case URLError.notConnectedToInternet.rawValue:
                            completion(.failure(NetworkServiceImplementation.Error.offlined))
                        case URLError.timedOut.rawValue:
                            completion(.failure(NetworkServiceImplementation.Error.timeOut))
                        default:
                            completion(.failure(NetworkServiceImplementation.Error.propagated(error)))
                        }
                    }
                }
            }
        }
    }
    
    func fetchData(completion: @escaping (Result<NetworkData, NetworkServiceImplementation.Error>) -> Void) {
        requestService.GET(url: URL(string: listPath)!) { (result: Result<NetworkData, NetworkRequestImplementation.Error>) in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                switch error {
                case let .propagated(error):
                    let error = error as NSError
                    switch error.code {
                    case URLError.notConnectedToInternet.rawValue:
                        completion(.failure(NetworkServiceImplementation.Error.offlined))
                    default:
                        completion(.failure(NetworkServiceImplementation.Error.propagated(error)))
                    }
                }
            }
        }
    }
}
