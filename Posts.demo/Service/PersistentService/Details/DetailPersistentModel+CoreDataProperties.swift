//
//  DetailPersistentModel+CoreDataProperties.swift
//  Posts.demo
//
//  Created by devmac on 23.12.2021.
//
//

import Foundation
import CoreData


extension DetailPersistentModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailPersistentModel> {
        return NSFetchRequest<DetailPersistentModel>(entityName: "DetailPersistentModel")
    }

    @NSManaged public var postId: Int32
    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var likesCount: Int32
    @NSManaged public var timestamp: Int32

}

extension DetailPersistentModel : Identifiable {

}
