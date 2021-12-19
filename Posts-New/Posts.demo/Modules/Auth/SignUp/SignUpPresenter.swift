//
//  AuthPresenter.swift
//  Posts.demo
//
//  Created by devmac on 13.12.2021.
//

import Foundation

protocol SignUpPresenter {
    func termsOfServiceStateChanged(_ value: Bool)
    func navigateToLogin()
    func termsOfServiceButtonClicked()
    func loginTextFieldDidChange(_ value: String)
    func passwordTextFieldDidChange(_ value: String)
    func passwordConfirmationTextFieldDidChange(_ value: String)
    func submitButtonClicked()
}

final class SignUpPresenterImplementation {
    weak var view: SignUpViewControllerProtocol?
    private let router: SignUpRouter
    
    private var userData = UserForm.defaultInstance
    
    private let passwordMinimumLength: Int = 6
    
    private var isAcceptedTermsOfService: Bool = false
    
    init(view: SignUpViewControllerProtocol, router: SignUpRouter) {
        self.view = view
        self.router = router
    }
    
    private func validateUserForm() -> Bool {
        var isFormValid = true
        
        let isUsernameAlphabetNumeric = (userData.username ?? "").isAlphanumeric()
        let uppercaseLetters = CharacterSet.uppercaseLetters
        let passwordIncludesCapitalization = (userData.password ?? "").unicodeScalars.contains(where: { element in
            uppercaseLetters.contains(element)
        })
        if !isUsernameAlphabetNumeric {
            isFormValid = false
            self.view?.showValidationError(with: .invalidUsername)
            return isFormValid
        }
        let isPasswordLengthValid = (userData.password ?? "").count >= passwordMinimumLength
        !isPasswordLengthValid {
            isFormValid = false
            self.view?.showValidationError(with: .shortPassword)
            return isFormValid
        }
        if !passwordIncludesCapitalization {
            isFormValid = false
            self.view?.showValidationError(with: .missingUppercasedLetter)
            return isFormValid
        }
        let passwordsMatch = userData.password == userData.passwordConfirmation
        if !passwordsMatch {
            isFormValid = false
            self.view?.showValidationError(with: .passwordNotConfirmed)
            return isFormValid
        }
        return isFormValid
    }
}


extension SignUpPresenterImplementation: SignUpPresenter {
    func loginTextFieldDidChange(_ value: String) {
        userData.username = value
    }
    
    func passwordTextFieldDidChange(_ value: String) {
        userData.password = value
    }
    
    func passwordConfirmationTextFieldDidChange(_ value: String) {
        userData.passwordConfirmation = value
    }
    
    func submitButtonClicked() {
        auth()
    }
    func termsOfServiceButtonClicked() {
        router.showTermsOfService()
    }
    
    func navigateToLogin() {
        router.showLogin()
    }
    
    private func auth() {
        if validateUserForm() {
            signUp { [weak self] result in
                if result {
                    self?.router.showFeed()
                } else {
                    self?.view?.showValidationError(with: .userAlreadyExist)
                }
            }
        }
    }
    
    func termsOfServiceStateChanged(_ value: Bool) {
        isAcceptedTermsOfService = value
        view?.termsOfServiceStateChanged(value)
    }
    
    private func signUp(completion: @escaping (Bool) -> Void) {
        var result = false
        if JSONService.shared.register(user: userData) {
            KeychainService.shared.set(userData.username ?? "", for: kUsername)
            KeychainService.shared.set(userData.username ?? "", for: kPassword)
            result = true
        }
        completion(result)
    }
}

public let kUsername = "username"
public let kPassword = "password"
