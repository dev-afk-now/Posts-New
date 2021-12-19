//
//  SignInPresenter.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import Foundation

protocol SignInPresenter {
    func submitButtonClicked()
    func navigateToRegistration()
    func loginTextFieldDidChange(_ value: String)
    func passwordTextFieldDidChange(_ value: String)
}

final class SignInPresenterImplementation {
    weak var view: SignInViewControllerProtocol?
    private let router: SignInRouter
    
    private var userData = UserForm.defaultInstance
    
    private var isAcceptedTermsOfService: Bool = false
    
    init(view: SignInViewControllerProtocol, router: SignInRouter) {
        self.view = view
        self.router = router
    }
}

extension SignInPresenterImplementation: SignInPresenter {
    func loginTextFieldDidChange(_ value: String) {
        userData.username = value
    }
    
    func passwordTextFieldDidChange(_ value: String) {
        userData.password = value
    }
    
    func navigateToRegistration() {
        router.showRegistration()
    }
    
    func submitButtonClicked() {
        signIn { [weak self] error in
            if let error = error {
                self?.view?.showValidationError(with: error)
            } else {
                self?.router.changeFlow()
            }
        }
    }
    
    private func signIn(completion: @escaping (ValidationError?) -> Void) {
        if let remoteUser = JSONService.shared.getUser(user: userData) {
            if remoteUser.password != userData.password {
                completion(.incorrectPasswordOrUserName)
            } else {
                KeychainService.shared.set(userData.username ?? "",
                                           for: kUsername)
                KeychainService.shared.set(userData.username ?? "",
                                           for: kPassword)
                completion(nil)
            }
        } else {
            completion(.invalidUser)
        }
    }
}
