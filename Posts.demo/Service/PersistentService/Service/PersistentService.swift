//
//  PersistentManager.swift
//  Posts.demo
//
//  Created by devmac on 17.12.2021.
//

import Foundation
import CoreData

public let context = PersistentService.shared.container.viewContext

final class PersistentService {
    static let shared = PersistentService()
    let container: NSPersistentContainer = {
        let persistentContatiner = NSPersistentContainer(name: "PostPersistent")
        persistentContatiner.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return persistentContatiner
    }()
    
    private init() {}
    
    func fetchObjects<T: NSManagedObject>(entity: T.Type) -> [T] {
        let context = container.viewContext
        
        let entityName = String(describing: T.self)
        let fetchRequest = NSFetchRequest<T>.init(entityName: entityName)
        do {
            let list = try context.fetch(fetchRequest)
            return list
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func save() {
        try? context.save()
    }
}
