//
//  ImageRequest.swift
//  Posts.demo
//
//  Created by New Mac on 20.10.2021.
//

import UIKit

protocol ImageRequest {
    func GET(url: URL, completion: @escaping(URL?) -> Void)
}

final class ImageRequestImplementation {}

extension ImageRequestImplementation: ImageRequest {
    func GET(url: URL, completion: @escaping(URL?) -> Void) {
        URLSession.shared.downloadTask(with: url) { urlLocal, _, error in
            guard error == nil, urlLocal != nil else {
                completion(nil)
                return
            }
            completion(urlLocal)
        }.resume()
    }
}
