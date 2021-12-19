//
//  JSONService.swift
//  Posts.demo
//
//  Created by devmac on 15.12.2021.
//

import Foundation

final class JSONService {
    
    static let shared = JSONService()
    
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
            
            result = try FileManager.saveObjects(list: storage, to: "users")
        } catch {
            print(error.localizedDescription)
            return false
        }
        return result
    }
    
    func getUser(user: UserForm) -> UserForm? {
        var resultUser: UserForm?
        let users: [UserForm] = getAllUsers()
        let result = users.first { $0.username == user.username }
        resultUser = result
        return resultUser
    }
    
    func getAllUsers() -> [UserForm] {
        var users = [UserForm]()
        let storage: LocalAccountStorage?
        do {
            storage = try FileManager.loadObjects(from: "users")
            users = storage?.users ?? []
        } catch let error as NSError {
            debugPrint(error)
        }
        return users
    }
}
