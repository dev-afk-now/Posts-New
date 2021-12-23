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
        images = model.images as? [String] ?? []
        print(model.images)
        print("readed from coreData \(model.postId)")
    }
}

extension DetailModel {
    func initPersistent() {
        let object = DetailPersistentModel(context: context)
        object.postId = self.postId.int32
        object.likesCount = self.likesCount.int32
        object.timestamp = self.timestamp.int32
        object.text = self.text
        object.title = self.title
        object.images = self.images as? [NSString] ?? []
        print("created detail: \(images)")
    }
}

extension DetailModel {
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
}
