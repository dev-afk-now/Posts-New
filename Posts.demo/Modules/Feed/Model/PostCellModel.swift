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

extension PostCellModel {
    func generateDatabaseModel() {
        let object = PostPersistent(context: PersistentService.shared.context)
        object.postId = self.postId.int32value
        object.likesCount = self.likesCount.int32value
        object.timestamp = self.timestamp.int32value
        object.text = self.text
        object.title = self.title
    }
}

extension Int {
    var int32value: Int32 {
        Int32(self)
    }
}
