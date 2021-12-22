//
//  KeychainService.swift
//  Posts.demo
//
//  Created by devmac on 14.12.2021.
//

import KeychainSwift

final class KeychainService {
    
    static let shared = KeychainService()
    private init() {}
    
    private let keychain = KeychainSwift()
    
    static var isUserLoggedIn: Bool {
        if !(KeychainService.shared.get(key: kUsername) ?? "").isEmpty,
           !(KeychainService.shared.get(key: kPassword) ?? "").isEmpty {
            return true
        } else {
            return false
        }
        
    }
    
    func set(_ value: String, for key: String) {
        if keychain.set(value, forKey: key) {
            print(" - successfully saved \(value) for \(key)")
        } else {
            print(" - saving failed")
        }
    }
    
    func get(key: String) -> String? {
        return keychain.get(key)
    }
    
    func clear() {
        keychain.clear()
    }
}
