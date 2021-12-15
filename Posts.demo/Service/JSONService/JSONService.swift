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
        do {
            var usersList = getAllUsers()
            guard usersList.filter{ $0.username == user.username }.isEmpty else {
                return false
            }
            usersList.append(user)
            
            let storage = Storage(users:usersList)
            
            try FileManager.saveObjects(list: storage, to: "users")
        } catch {
            print(error.localizedDescription)
        }
        return true
    }
    
    func getUser(user: UserForm) -> UserForm? {
        var resultUser: UserForm?
        let users: [UserForm] = getAllUsers()
        let result = users.filter { $0.username == user.username ?? ""}
        resultUser = result.first
        return resultUser
    }
    
    func getAllUsers() -> [UserForm] {
        var users = [UserForm]()
        let storage: Storage?
        do {
            storage = try FileManager.loadObjects(from: "users")
            users = storage?.users ?? []
        } catch let error as NSError {
            debugPrint(error)
            print("")
        }
        return users
    }
}
