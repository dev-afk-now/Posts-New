import UIKit
import CryptoKit

struct StorageModel: Codable {
    var users: [DataModel]
}

struct DataModel: Codable {
    var username: String
    var password: String
}



extension JSONSerialization {
    
    static func loadJSON(withFilename filename: String) throws -> Any? {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
            return jsonObject
        }
        return nil
    }
    
    static func save(jsonObject: Any, toFilename filename: String) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            try data.write(to: fileURL, options: [.atomicWrite])
            return true
        }
        
        return false
    }
}

let json: [String: Any] = ["username": "Nikita23",
                           "password": "Qwer123"]


var users = [DataModel]()
do {
    let isUploadedJson = try JSONSerialization.save(jsonObject: json,
                                              toFilename: "storage")

    if let downloadedJson = try JSONSerialization.loadJSON(withFilename: "storage") as? [String: Any] {
        
        print("our json is: \n \(downloadedJson)")
    }
} catch let error as NSError {
    print("Failed to load: \(error.localizedDescription)")
}
