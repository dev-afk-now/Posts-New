//
//  Post.swift
//  Posts.demo
//
//  Created by Никита Дубовик on 19.12.2021.
//

import Foundation

struct Post: Codable {
    var postId: Int
    var title: String
    var timeshamp: Int
    var preview_text: String
    var likes_count: Int
}
