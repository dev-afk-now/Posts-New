//
//  HashService.swift
//  Posts.demo
//
//  Created by New Mac on 25.11.2021.
//

import Foundation
import CryptoKit


final class HashService {
    
    static let shared = HashService()
    
    private let fileManager = FileManager.default
    
    private init() {}
    
    func save(data: Data, key: String) {
        
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let cachesDirectoryUrl = urls[0]
        let fileUrl = cachesDirectoryUrl.appendingPathComponent(MD5(string: key))
        let filePath = fileUrl.path
        if !fileManager.fileExists(atPath: filePath) {
            fileManager.createFile(atPath: filePath, contents: data)
            print(" - \(key) created with data: \(data)")
        } else {
            print(" - \(key) already exists with data: \(data)")
        }
    }
    
    func get(by key: String) -> URL? {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let cachesDirectoryUrl = urls[0]
        let fileUrl = cachesDirectoryUrl.appendingPathComponent(MD5(string: key))
        if fileManager.fileExists(atPath: fileUrl.path) {
            print(" - \(key) readed from cache")
            return fileUrl
        } else {
            return nil
        }
    }
    
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
