//
//  AuthPresenter.swift
//  Posts.demo
//
//  Created by devmac on 13.12.2021.
//

import Foundation

protocol SignUpPresenter {
    func termsOfServiceStateChanged(_ value: Bool)
    func auth(username: String, password: String, passwordConfirmation: String)
    func navigateToLogin()
    func termsOfServiceButtonClicked()
}

final class SignUpPresenterImplementation {
    weak var view: SignUpViewControllerProtocol?
    private let router: SignUpRouter
    
    private var userData = UserForm.defaultInstance
    
    private var isAcceptedTermsOfService: Bool = false
    
    init(view: SignUpViewControllerProtocol, router: SignUpRouter) {
        self.view = view
        self.router = router
    }
    
    
    
    private func validateUserForm() -> Bool {
        var isFormValid = true
        
        let isUsernameAlphabetNumeric = (userData.username ?? "").isAlphanumeric()
        let uppercaseLetters = CharacterSet.uppercaseLetters
        let isPasswordHaveUppercasedChar = (userData.password ?? "").unicodeScalars.contains(where: { element in
            uppercaseLetters.contains(element)
        })
        if !isUsernameAlphabetNumeric {
            isFormValid = false
            self.view?.showValidateFailure(with: .invalidUsername)
            return isFormValid
        }
        let isPasswordLongEnough = (userData.password ?? "").count >= 6
        if !isPasswordLongEnough {
            isFormValid = false
            self.view?.showValidateFailure(with: .shortPassword)
            return isFormValid
            
        }
        if !isPasswordHaveUppercasedChar {
            isFormValid = false
            self.view?.showValidateFailure(with: .missingUppercasedLetter)
            return isFormValid
            
        }
        let isPasswordsMatch = userData.password == userData.passwordConfirmation
        if !isPasswordsMatch {
            isFormValid = false
            self.view?.showValidateFailure(with: .passwordNotConfirmed)
            return isFormValid
        }
        
        return isFormValid
    }
    
}


extension SignUpPresenterImplementation: SignUpPresenter {
    func termsOfServiceButtonClicked() {
        router.showTermsOfService()
    }
    
    func navigateToLogin() {
        router.showLogin()
    }
    
    func auth(username: String, password: String, passwordConfirmation: String) {
        userData = UserForm(username: username,
                            password: password,
                            passwordConfirmation: passwordConfirmation)
        if validateUserForm() {
            signUp { [weak self] result in
                if result {
                    self?.router.showFeed()
                } else {
                    self?.view?.showValidateFailure(with: .userAlreadyExist)
                }
            }
        }
    }
    
    func termsOfServiceStateChanged(_ value: Bool) {
        isAcceptedTermsOfService = value
        view?.turnViewsIntoUnabledStateIfNeed(value)
    }
    
    private func signUp(completion: @escaping (Bool) -> Void) {
        var result = false
        if JSONService.shared.register(user: userData) {
            KeychainService.shared.clear()
            KeychainService.shared.set(userData.username ?? "", for: kUsername)
            result = true
        }
        completion(result)
    }
}

public enum ValidationError {
    case userAlreadyExist
    case invalidUser
    case incorrectPassword
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
        case .incorrectPassword:
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


public let kUsername = "username"
public let kPassword = "password"

extension String {
    func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
}
