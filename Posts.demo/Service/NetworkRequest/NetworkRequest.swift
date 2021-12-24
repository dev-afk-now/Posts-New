//
//  NetworkRequest.swift
//  Posts.demo
//
//  Created by New Mac on 08.10.2021.
//

import Foundation

protocol NetworkRequest {
    func GET<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkRequestImplementation.Error>) -> Void)
}

final class NetworkRequestImplementation {
    enum Error: Swift.Error {
        case propagated(Swift.Error)
    }
}

extension NetworkRequestImplementation: NetworkRequest {    
    func GET<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                completion(.failure(Error.propagated(error!)))
                return
            }
            guard let data = data else {
                let context = DecodingError.Context(codingPath: [], debugDescription: "data corrupted")
                completion(.failure(Error.propagated(DecodingError.dataCorrupted(context))))
                return
            }
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(parsedData))
            } catch let error {
                completion(.failure(Error.propagated(error)))
            }
        }.resume()
    }
}
