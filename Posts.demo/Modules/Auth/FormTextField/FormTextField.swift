//
//  FormTextField.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import UIKit

class FormTextField: UITextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    init(placeholder: String = "", isSecured: Bool = false) {
        super.init(frame: .zero)
        setupStyle(placeholder: placeholder, isSecured: isSecured)
    }
    
    private func setupStyle(placeholder: String = "", isSecured: Bool = false) {
        self.autocorrectionType = .no
        self.borderStyle = .roundedRect
        self.isSecureTextEntry = isSecured
        self.cornerRadius = 8
        self.placeholder = placeholder
    }
}
