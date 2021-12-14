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

struct Post: Codable {
    var postId: Int
    var title: String
    var timeshamp: Int
    var preview_text: String
    var likes_count: Int
}

struct NetworkPost: Codable {
    var post: ConcretePost
}

struct ConcretePost: Codable {
    var postId: Int
    var timeshamp: Int
    var title: String
    var text: String
    var images: [String]
    var likes_count: Int
}

extension ConcretePost {
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(timeshamp))
    }
}
