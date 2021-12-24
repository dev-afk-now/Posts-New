//
//  Model.swift
//  Posts.demo
//
//  Created by devmac on 14.12.2021.
//

import Foundation

struct NetworkData: Codable {
    var posts: [Post]
}

struct NetworkPost: Codable {
    var post: ConcretePost
}

