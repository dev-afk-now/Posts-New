//
//  FormTextField.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import UIKit

class FormTextField: UITextField {
    
    var internalType: FormTextFieldType = .notDefined
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    init(type: FormTextFieldType) {
        super.init(frame: .zero)
        internalType = type
        setupStyle()
    }
    
    private func setupStyle() {
        self.autocorrectionType = .no
        self.borderStyle = .roundedRect
        self.placeholder = internalType.placeholder
        self.isSecureTextEntry = internalType.isSecured
        self.cornerRadius = 8
    }
}

enum FormTextFieldType {
    case notDefined
    case username
    case password
    case confirmPassword
    
    var placeholder: String {
        switch self {
        case .notDefined:
            return ""
        case .username:
            return "Имя пользователя"
        case .password:
            return "Пароль"
        case .confirmPassword:
            return "Подтвердите пароль"
        }
    }
    
    var isSecured: Bool {
        (self == .password || self == .confirmPassword) ? true : false
    }
}

