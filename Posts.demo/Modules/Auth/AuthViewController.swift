//
//  AuthViewController.swift
//  Posts.demo
//
//  Created by devmac on 13.12.2021.
//

import UIKit

protocol AuthViewControllerProtocol: AnyObject {
    func updateView()
    func turnViewsIntoUnabledStateIfNeed(_ value: Bool)
    func showValidateFailure(with errorType: ValidationError)
}

class AuthViewController: UIViewController {
    
    var presenter: AuthPresenter!
    
    // MARK: - Private variables -
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 16
        stack.layer.cornerRadius = 10
        stack.layer.borderWidth = 0.5
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.clipsToBounds = true
        return stack
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Регистрация"
        label.font = UIFont(name: "Helvetica Neue", size: 26)
        label.textColor = .black
        return label
    }()
    
    private lazy var loginTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Username"
        field.autocorrectionType = .no
        field.borderStyle = .roundedRect
        field.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        return field
    }()
    
    private lazy var passwordTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        field.placeholder = "Password"
        field.autocorrectionType = .no
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 8
        field.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        return field
    }()
    
    private lazy var repeatPasswordTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        field.placeholder = "Repeat password"
        field.autocorrectionType = .no
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 8
        field.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        return field
    }()
    
    private lazy var termsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "I agree with terms of service"
        label.textColor = .lightGray
        label.font = UIFont(name: "Helvetica Neue", size: 16)
        return label
    }()
    
    private lazy var termsOfServiceSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.addAction(UIAction(handler: { [unowned self] _ in
            self.presenter.termsOfServiceStateChanged(self.termsOfServiceSwitcher.isOn)
        }), for: .valueChanged)
        return switcher
    }()
    
    private lazy var termsOfServiceContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.presenter.auth(username: self.loginTextField.text ?? "", password: self.passwordTextField.text ?? "", passwordConfirmation: self.repeatPasswordTextField.text ?? "")
        }), for: .touchUpInside)
        button.isEnabled = false
        button.backgroundColor = .lightGray
        return button
    }()
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupConstraints()
    }
    
    private func initialSetup() {
        view.backgroundColor = .white
        setupStackViewLayout()
        stackView.addArrangedSubview(signUpLabel)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(repeatPasswordTextField)
        stackView.addArrangedSubview(termsOfServiceContainer)
        termsOfServiceContainer.addArrangedSubview(termsOfServiceSwitcher)
        termsOfServiceContainer.addArrangedSubview(termsOfServiceLabel)
        stackView.addArrangedSubview(submitButton)
    }
    
    private func setupStackViewLayout() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupConstraints() {
       // let screenWidth: CGFloat = UIScreen.main.bounds.width
        let horizontalInset: CGFloat = 32
        NSLayoutConstraint.activate([
            signUpLabel.heightAnchor.constraint(equalToConstant: 40),
            
            loginTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: horizontalInset),
            loginTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -horizontalInset),
            loginTextField.heightAnchor.constraint(equalToConstant: 40),
            
            repeatPasswordTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: horizontalInset),
            repeatPasswordTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -horizontalInset),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: horizontalInset),
            passwordTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -horizontalInset),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            submitButton.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func enterPressed() {
        view.endEditing(true)
    }
}

extension AuthViewController: AuthViewControllerProtocol {
    func showValidateFailure(with errorType: ValidationError) {
    }
    
    func turnViewsIntoUnabledStateIfNeed(_ value: Bool) {
        switch value {
        case true:
            submitButton.isEnabled = true
            submitButton.tintColor = .blue
            submitButton.backgroundColor = .black
            termsOfServiceLabel.textColor = .black
            print("state -> true")
        case false:
            print("state -> false")
            submitButton.isEnabled = false
            termsOfServiceLabel.textColor = .lightGray
            submitButton.tintColor = .red
            submitButton.backgroundColor = .lightGray
        }
    }
    
    func updateView() {
        //
    }
}

extension AuthViewController: UITextFieldDelegate {}
