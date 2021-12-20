//
//  Date.swift
//  Posts.demo
//
//  Created by devmac on 14.12.2021.
//

import Foundation

extension Date {
    func toStringShort() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
}

extension Date {
    static func dateStringFromTimestamp(_ timestamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let time = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return formatter.string(from: time)
    }
}
