//
//  AuthPresenter.swift
//  Posts.demo
//
//  Created by devmac on 13.12.2021.
//

import Foundation

protocol SignUpPresenter {
    func termsOfServiceSwitchStateChanged(_ value: Bool)
    func validateAndSignUp()
    func updateUserForm(text: String, type: FormTextFieldType)
    func navigateToLogin()
    func openTermsOfService()
}

final class SignUpPresenterImplementation {
    weak var view: SignUpViewControllerProtocol?
    
    // MARK: - Private properties -
    
    private let router: SignUpRouter
    private var userData = UserForm.defaultInstance
    private let minPasswordLength: Int = 6
    private var isAcceptedTermsOfService: Bool = false
    
    // MARK: - Init -
    
    init(view: SignUpViewControllerProtocol, router: SignUpRouter) {
        self.view = view
        self.router = router
    }
    
    // MARK: - Private methods -
    
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
        let isPasswordLengthValid = (userData.password ?? "").count >= minPasswordLength
        if !isPasswordLengthValid {
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
    
    private func signUp(completion: @escaping (Bool) -> Void) {
        var result = false
        if JSONService.shared.register(user: userData) {
            KeychainService.shared.set(userData.username ?? "", for: kUsername)
            KeychainService.shared.set(userData.password ?? "", for: kPassword)
            result = true
        }
        completion(result)
    }
}

// MARK: - SignUpPresenterImplementation extensions -

extension SignUpPresenterImplementation: SignUpPresenter {
    func updateUserForm(text: String, type: FormTextFieldType) {
        switch type {
        case .username:
            userData.username = text
        case .password:
            userData.password = text
        case .confirmPassword:
            userData.passwordConfirmation = text
        default:
            break
        }
    }
    
    func openTermsOfService() {
        router.showTermsOfService()
    }
    
    func navigateToLogin() {
        router.showLogin()
    }
    
    func validateAndSignUp() {
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
    
    func termsOfServiceSwitchStateChanged(_ value: Bool) {
        isAcceptedTermsOfService = value
        view?.changeTermsOfServiceState(value)
    }
}

public let kUsername = "username"
public let kPassword = "password"
