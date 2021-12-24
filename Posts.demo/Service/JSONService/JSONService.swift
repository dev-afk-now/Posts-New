//
//  JSONService.swift
//  Posts.demo
//
//  Created by devmac on 15.12.2021.
//

import Foundation

final class JSONService {
    
    static let shared = JSONService()
    
    private let accountStorageName = "users"
    
    private init() {}
    
    func register(user: UserForm) -> Bool {
        var result = true
        do {
            var usersList = getAllUsers()
            guard usersList.filter({ $0.username == user.username }).isEmpty else {
                return false
            }
            usersList.append(user)
            
            let storage = LocalAccountStorage(users:usersList)
            
            result = try FileManager.saveObjects(list: storage, to: accountStorageName)
        } catch {
            print(error.localizedDescription)
            return false
        }
        return result
    }
    
    func getUser(user: UserForm) -> UserForm? {
        let users: [UserForm] = getAllUsers()
        return users.first{ $0.username == user.username }
    }
    
    func getAllUsers() -> [UserForm] {
        var users = [UserForm]()
        let storage: LocalAccountStorage?
        do {
            storage = try FileManager.loadObjects(from: accountStorageName)
            users = storage?.users ?? []
        } catch let error as NSError {
            debugPrint(error)
        }
        return users
    }
}
