//
//  DetailModel.swift
//  Posts.demo
//
//  Created by devmac on 23.12.2021.
//

import Foundation

struct DetailModel {
    var postId: Int
    var timestamp: Int
    var title: String
    var text: String
    var images: [String]
    var likesCount: Int
    
    init(_ model: Detail) {
        postId = model.postId
        title = model.title
        text = model.text
        likesCount = model.likes_count
        timestamp = model.timeshamp
        images = model.images
    }
    
    init(from model: DetailPersistentModel) {
        postId = Int(model.postId)
        title = model.title ?? ""
        text = model.text ?? ""
        likesCount = Int(model.likesCount)
        timestamp = Int(model.timestamp)
        images = model.images
    }
}

extension DetailModel {
    func generateDatabaseModel() {
        let object = DetailPersistentModel(context: PersistentService.shared.context)
        object.postId = self.postId.int32value
        object.likesCount = self.likesCount.int32value
        object.timestamp = self.timestamp.int32value
        object.text = self.text
        object.title = self.title
        object.images = self.images
    }
}

extension DetailModel {
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
}
