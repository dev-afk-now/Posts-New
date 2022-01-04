//
//  String+isAlphanumeric.swift
//  Posts.demo
//
//  Created by Никита Дубовик on 19.12.2021.
//

import Foundation

extension String {
    func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
}
