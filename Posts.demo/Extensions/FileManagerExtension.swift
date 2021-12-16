//
//  FileManager.swift
//  Posts.demo
//
//  Created by devmac on 15.12.2021.
//

import Foundation

extension FileManager {
    static func saveObjects<T: Encodable>(list: T,
                                          to fileName: String) throws -> Bool {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(fileName)
            fileURL = fileURL.appendingPathExtension("json")
            let encodedObjects = try JSONEncoder().encode(list)
            try encodedObjects.write(to: fileURL, options: [.atomicWrite])
            print(fileURL.absoluteString)
            return true
        }
        return false
    }
    
    static func loadObjects<T: Decodable>(from fileName: String) throws -> T? {
        var list: T?
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(fileName)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let decodedObjects = try JSONDecoder().decode(T.self,
                                                          from: data)
            list = decodedObjects
        }
        return list
    }
}
