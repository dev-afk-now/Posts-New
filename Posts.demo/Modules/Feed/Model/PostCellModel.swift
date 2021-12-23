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
    
    init(_ model: Response) {
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
        print("readed \(model.postId)")
    }
}

extension PostCellModel {
    var likes: String {
        String(likesCount)
    }
}

extension PostCellModel {
    func initPersistent() {
        let object = PostPersistent(context: context)
        object.postId = self.postId.int32
        object.likesCount = self.likesCount.int32
        object.timestamp = self.timestamp.int32
        object.text = self.text
        object.title = self.title
        print("created post: \(object.postId)")
    }
}

extension Int {
    var int32: Int32 {
        Int32(self)
    }
}
