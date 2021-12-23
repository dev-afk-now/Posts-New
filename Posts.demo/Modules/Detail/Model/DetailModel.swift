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
        self.postId = model.postId
        self.title = model.title
        self.text = model.text
        self.likesCount = model.likes_count
        self.timestamp = model.timeshamp
        self.images = model.images
    }
    
    init(from model: DetailPersistentModel) {
        self.postId = Int(model.postId)
        self.title = model.title ?? ""
        self.text = model.text ?? ""
        self.likesCount = Int(model.likesCount)
        self.timestamp = Int(model.timestamp)
        self.images = []
        print("readed from coreData \(model.postId)")
    }
}

extension DetailModel {
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
}
