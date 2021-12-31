//
//  PostPersistentAdapter.swift
//  Posts.demo
//
//  Created by devmac on 31.12.2021.
//

import Foundation

final class PostPersistentAdapter {
    static let shared = PostPersistentAdapter()
    
    private init() {}
    
    func generateDatabasePostObjects(from postList: [PostCellModel]) {
        postList.forEach{ generateDatabasePostObject(from: $0) }
    }
    
    func generateDatabasePostObject(from postModel: PostCellModel) {
        let object = PostPersistent(context: PersistentService.shared.context)
        object.postId = postModel.postId.int32value
        object.likesCount = postModel.likesCount.int32value
        object.timestamp = postModel.timestamp.int32value
        object.text = postModel.text
        object.title = postModel.title
        PersistentService.shared.save()
    }
    
    func pullDatabasePostObjects() -> [PostPersistent] {
        return PersistentService.shared.fetchObjects(entity: PostPersistent.self)
    }
}
