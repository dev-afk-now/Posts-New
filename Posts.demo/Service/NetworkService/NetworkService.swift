//
//  NetworkService.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import Foundation

protocol NetworkService {
    func fetchData<T: Codable>(url: URL, completion: @escaping (Result<T, NetworkServiceImplementation.Error>) -> Void)
}

final class NetworkServiceImplementation {
    
    enum Error: Swift.Error {
        case propagated(Swift.Error)
        case offlined
        case timeOut
    }

    private var requestService: NetworkRequest!
    
    
    init(requestService: NetworkRequest) {
        self.requestService = requestService
    }
}

extension NetworkServiceImplementation: NetworkService {
    func fetchData<T: Codable>(url: URL,
                               completion: @escaping (Result<T, NetworkServiceImplementation.Error>) -> Void) {
        requestService.GET(url: url) { (result: Result<T, NetworkRequestImplementation.Error>) in
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
        return
    }
}
