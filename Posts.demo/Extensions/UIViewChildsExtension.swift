//
//  UIView.swift
//  Posts.demo
//
//  Created by devmac on 14.12.2021.
//

import UIKit

extension UIView {
    func configureBorder(width: CGFloat, with color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    var cornerRadius: CGFloat {
        get {
            self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

extension UIView {
    func makeGradient(colors: [UIColor]) {
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.colors = colors.map {$0.cgColor}
        self.isUserInteractionEnabled = false
        self.layer.insertSublayer(gradient, at: 0)
    }
}

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
