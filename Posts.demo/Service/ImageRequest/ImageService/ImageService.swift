//
//  ImageService.swift
//  Posts.demo
//
//  Created by New Mac on 20.10.2021.
//

import UIKit

protocol ImageService {
    func fetchImages(_ urls: [URL?], completion: @escaping([URL?]) -> Void)
}

final class ImageServiceImplementation {
    enum Error: Swift.Error {
        case invalidURL
        case offlined
        case propagated
    }
    
    private var requestService: ImageRequest!
    
    init(requestService: ImageRequest) {
        self.requestService = requestService
    }
}

extension ImageServiceImplementation: ImageService {
    
    func fetchImages(_ urls: [URL?], completion: @escaping ([URL?]) -> Void) {
        let group = DispatchGroup()
        var order: [URL: URL] = [:]
        for url in urls {
            guard let value = url else { continue }
            group.enter()
            fetchImage(url) { output in
                order[value] = output
                group.leave()
            }
        }
        group.notify(queue: .main) {
            let result = urls.map { value -> URL? in
                guard let value = value else {
                    return nil
                }
                return order[value]
            }
            completion(result)
        }
    }
    
    private func fetchImage(_ url: URL?,
                            completion: @escaping (URL?) -> ()) {
        guard let url = url else {
            completion(nil)
            return
        }
        guard let loadedUrl = HashService.shared.get(by: url.absoluteString) else {
            requestService.GET(url: url) { result in
                guard let localUrl = result else {
                    completion(nil)
                    return
                }
                guard let data = try? Data(contentsOf: localUrl) else {
                    completion(nil)
                    return
                }
                HashService.shared.save(data: data, key: url.absoluteString)
                let result = HashService.shared.get(by: url.absoluteString)
                result == nil ? completion(nil) : completion(result)
            }
            return
        }
        completion(loadedUrl)
    }
}
