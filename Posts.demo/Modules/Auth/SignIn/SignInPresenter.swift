//
//  SignInPresenter.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import Foundation

protocol SignInPresenter {
    func auth()
    func updateUserForm(text: String, type: FormTextFieldType)
    func navigateToRegistration()
}

final class SignInPresenterImplementation {
    weak var view: SignInViewControllerProtocol?
    
    // MARK: - Private vars -
    
    private let router: SignInRouter
    
    private var userData = UserForm.defaultInstance
    
    private var isAcceptedTermsOfService: Bool = false
    
    init(view: SignInViewControllerProtocol, router: SignInRouter) {
        self.view = view
        self.router = router
    }
    
    // MARK: - Private funcs -
    
    private func signIn(completion: @escaping (ValidationError?) -> Void) {
        if let remoteUser = JSONService.shared.getUser(user: userData) {
            if remoteUser.password != userData.password,
               remoteUser.username != userData.username {
                completion(.incorrectPasswordOrUserName)
            } else {
                KeychainService.shared.set(userData.username ?? "", for: kUsername)
                KeychainService.shared.set(userData.password ?? "", for: kPassword)
                completion(nil)
            }
        } else {
            completion(.invalidUser)
        }
    }
}


extension SignInPresenterImplementation: SignInPresenter {
    func updateUserForm(text: String, type: FormTextFieldType) {
        switch type {
        case .username:
            userData.username = text
        case .password:
            userData.password = text
        case .confirmPassword:
            break
        case .notDefined:
            break
        }
    }
    
    func navigateToRegistration() {
        router.showRegistration()
    }
    
    func auth() {
        
        // TODO: Метод валидации, чтобы не гонять трафик зря
        
        signIn { [weak self] error in
            if let error = error {
                self?.view?.showValidationError(with: error)
            } else {
                self?.router.changeFlow()
            }
        }
    }
}

