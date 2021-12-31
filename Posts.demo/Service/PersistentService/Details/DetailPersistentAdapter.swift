//
//  DetailAdapter.swift
//  Posts.demo
//
//  Created by devmac on 31.12.2021.
//

import Foundation

final class DetailPersistentAdapter {
    static let shared = DetailPersistentAdapter()
    
    private init() {}
    
    func generateDatabaseDetailObjects(from detailList: [DetailModel]) {
        detailList.forEach{ generateDatabaseDetailObject(from: $0) }
    }
    
    func generateDatabaseDetailObject(from detailModel: DetailModel) {
        let object = DetailPersistentModel(context: PersistentService.shared.context)
        object.postId = detailModel.postId.int32value
        object.likesCount = detailModel.likesCount.int32value
        object.timestamp = detailModel.timestamp.int32value
        object.text = detailModel.text
        object.title = detailModel.title
        object.images = detailModel.images
        PersistentService.shared.save()

    }
    
    func pullDatabaseDetailObject(by postId: Int) -> DetailPersistentModel? {
        let details = PersistentService.shared.fetchObjects(entity: DetailPersistentModel.self)
        return details.first { $0.postId == postId }
    }
}
