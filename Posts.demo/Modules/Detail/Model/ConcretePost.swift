//
//  ConcretePost.swift
//  Posts.demo
//
//  Created by Никита Дубовик on 19.12.2021.
//

import Foundation

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
