//
//  PostCellModel.swift
//  Posts.demo
//
//  Created by devmac on 06.12.2021.
//

import Foundation

struct PostCellModel {
    var postId: Int
    var title: String
    var timestamp: Int
    var text: String
    var likesCount: Int
    var isShowingFullPreview: Bool
    
    init(_ model: Post) {
        self.postId = model.postId
        self.title = model.title
        self.text = model.preview_text
        self.isShowingFullPreview = false
        self.likesCount = model.likes_count
        self.timestamp = model.timeshamp
    }
}

extension PostCellModel {
    var likes: String {
        String(likesCount)
    }
}
