//
//  UserForm.swift
//  Posts.demo
//
//  Created by devmac on 14.12.2021.
//

import Foundation

struct Storage: Codable {
    var users: [UserForm]
}

class UserForm: Codable {
    var username: String?
    var password: String?
    var passwordConfirmation: String?
    
    init() {}
    
    init(username: String, password: String, passwordConfirmation: String) {
        self.username = username
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
    
    static var defaultInstance: UserForm {
        return UserForm()
    }
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(username,
                                      forKey: .username)
        try container.encodeIfPresent(password,
                                      forKey: .password)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decodeIfPresent(String.self,
                                                 forKey: .username)
        password = try container.decodeIfPresent(String.self,
                                                 forKey: .password)
        
    }
}
