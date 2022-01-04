//
//  PostPersistent+CoreDataProperties.swift
//  Posts.demo
//
//  Created by devmac on 17.12.2021.
//
//

import Foundation
import CoreData

extension PostPersistent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostPersistent> {
        return NSFetchRequest<PostPersistent>(entityName: "PostPersistent")
    }

    @NSManaged public var postId: Int32
    @NSManaged public var title: String?
    @NSManaged public var timestamp: Int32
    @NSManaged public var text: String?
    @NSManaged public var likesCount: Int32
}
