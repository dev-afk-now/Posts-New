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
    
    init(from networkModel: Post) {
        self.postId = networkModel.postId
        self.title = networkModel.title
        self.text = networkModel.preview_text
        self.isShowingFullPreview = false
        self.likesCount = networkModel.likes_count
        self.timestamp = networkModel.timeshamp
    }
    
    init(from model: PostPersistent) {
        self.postId = Int(model.postId)
        self.title = model.title ?? ""
        self.text = model.text ?? ""
        self.isShowingFullPreview = false
        self.likesCount = Int(model.likesCount)
        self.timestamp = Int(model.timestamp)
    }
}

extension PostCellModel {
    var likes: String {
        String(likesCount)
    }
}

extension Int {
    var int32value: Int32 {
        Int32(self)
    }
}
