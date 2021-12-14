//
//  UserForm.swift
//  Posts.demo
//
//  Created by devmac on 14.12.2021.
//

import Foundation


struct UserForm {
    var username: String
    var password: String
    var passwordConfirmation: String
    
    static var defaultInstance: UserForm {
        return UserForm(username: "",
                        password: "",
                        passwordConfirmation: "")
    }
}
