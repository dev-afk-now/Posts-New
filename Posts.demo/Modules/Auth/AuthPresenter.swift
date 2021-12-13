//
//  AuthPresenter.swift
//  Posts.demo
//
//  Created by devmac on 13.12.2021.
//

import Foundation

protocol AuthPresenter {
    func termsOfServiceStateChanged(_ value: Bool)
    func auth(username: String, password: String, passwordConfirmation: String)
}

final class AuthPresenterImplementation {
    weak var view: AuthViewControllerProtocol?
    
    private var userData = UserForm.defaultInstance
    
    private var isAcceptedTermsOfService: Bool = false
    
    init(view: AuthViewControllerProtocol) {
        self.view = view
    }
    
    private func validateUserForm() -> Bool {
        var isFormValid = true
        let isUsernameAlphabetNumeric = userData.username.isAlphanumeric()
        let uppercaseLetters = CharacterSet.uppercaseLetters
        let isPasswordHaveUppercasedChar = userData.password.unicodeScalars.contains(where: { element in
            uppercaseLetters.contains(element)
        })
        if !isUsernameAlphabetNumeric {
            isFormValid = false
            self.view?.showValidateFailure(with: .invalidUsername)
        }
        let isPasswordLongEnough = userData.password.count >= 6
        if !isPasswordLongEnough {
            isFormValid = false
            self.view?.showValidateFailure(with: .shortPassword)
        }
        if !isPasswordHaveUppercasedChar {
            isFormValid = false
            self.view?.showValidateFailure(with: .missingUppercasedLetter)
        }
        let isPasswordsMatch = userData.password == userData.passwordConfirmation
        if !isPasswordsMatch {
            isFormValid = false
            self.view?.showValidateFailure(with: .passwordNotConfirmed)
        }
        
        return isFormValid
    }
    
}


extension AuthPresenterImplementation: AuthPresenter {

    
    func auth(username: String, password: String, passwordConfirmation: String) {
        userData = UserForm(username: username, password: password, passwordConfirmation: passwordConfirmation)
        if validateUserForm() {
            
        }
    }
    
    func termsOfServiceStateChanged(_ value: Bool) {
        isAcceptedTermsOfService = value
        view?.turnViewsIntoUnabledStateIfNeed(value)
    }
    
    func signUp() {
        //
    }
}

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

enum ValidationError {
    case invalidUsername
    case shortPassword
    case missingUppercasedLetter
    case passwordNotConfirmed
    
    var message: String {
        switch self {
        case .invalidUsername:
            return "Username must contain only A-Z symbols and numbers."
        case .shortPassword:
            return "Password must be more then 6 symbols"
        case .missingUppercasedLetter:
            return "Password must have one or more uppercase letter"
        case .passwordNotConfirmed:
            return "Passwords didn't match"
        }
    }
}

extension String {
    func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
}
