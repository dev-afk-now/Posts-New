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
    
    init(from networkModel: Detail) {
        postId = networkModel.postId
        title = networkModel.title
        text = networkModel.text
        likesCount = networkModel.likes_count
        timestamp = networkModel.timeshamp
        images = networkModel.images
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
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
}
