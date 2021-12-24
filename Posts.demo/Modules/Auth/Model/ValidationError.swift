//
//  ValidationError.swift
//  Posts.demo
//
//  Created by Никита Дубовик on 19.12.2021.
//

import Foundation

public enum ValidationError {
    case userAlreadyExist
    case invalidUser
    case incorrectPasswordOrUserName
    case invalidUsername
    case shortPassword
    case missingUppercasedLetter
    case passwordNotConfirmed
    
    var message: String {
        switch self {
        case .invalidUser:
            return "Account with this username don't exists"
        case .userAlreadyExist:
            return "Account with this username already exists."
        case .incorrectPasswordOrUserName:
            return "Incorrect password"
        case .invalidUsername:
            return "Username must contain only A-Z symbols and numbers."
        case .shortPassword:
            return "Password must be more then 6 symbols."
        case .missingUppercasedLetter:
            return "Password must have one or more uppercase letter"
        case .passwordNotConfirmed:
            return "Passwords don't match"
        }
    }
}
