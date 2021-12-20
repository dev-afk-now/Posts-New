//
//  SignInPresenter.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import Foundation

protocol SignInPresenter {
    func auth()
    func navigateToRegistration()
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
    func navigateToRegistration() {
        router.showRegistration()
    }
    
    func auth() {
        
        // TODO: Метод валидации, чтобы не гонять трафик зря
        
        signIn { [weak self] error in
            if let error = error {
                self?.view?.showValidateFailure(with: error)
            } else {
                self?.router.changeFlow()
            }
        }
    }
    
    private func signIn(completion: @escaping (ValidationError?) -> Void) {
        if let remoteUser = JSONService.shared.getUser(user: userData) {
            if remoteUser.password != userData.password {
                completion(.incorrectPassword)
            } else {
                KeychainService.shared.clear()
                KeychainService.shared.set(userData.username ?? "", for: kUsername)
                KeychainService.shared.set(userData.password ?? "", for: kPassword)
                completion(nil)
            }
        } else {
            completion(.invalidUser)
        }
    }
}
