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
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 16
        stack.cornerRadius = 10
        stack.configureBorder(width: 0.5, with: .lightGray)
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
    
    private lazy var loginTextField: FormTextField = {
        let field = FormTextField(placeholder: "Имя пользователя", isSecured: false)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        return field
    }()
    
    private lazy var passwordTextField: FormTextField = {
        let field = FormTextField(placeholder: "Пароль", isSecured: true)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        return field
    }()
    
    private lazy var repeatPasswordTextField: FormTextField = {
        let field = FormTextField(placeholder: "Повторите пароль", isSecured: true)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        return field
    }()
    
    private lazy var termsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Прочитал(а) Условия пользования"
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.font = UIFont(name: "Helvetica Neue", size: 16)
        return label
    }()
    
    private lazy var termsOfServiceSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.addAction(UIAction { [unowned self] _ in
            self.presenter.termsOfServiceStateChanged(self.termsOfServiceSwitcher.isOn)
        }, for: .valueChanged)
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
        button.addAction(UIAction { _ in
            self.presenter.auth(username: self.loginTextField.text ?? "", password: self.passwordTextField.text ?? "", passwordConfirmation: self.repeatPasswordTextField.text ?? "")
        }, for: .touchUpInside)
        button.isEnabled = false
        button.backgroundColor = .lightGray
        return button
    }()
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupConstraints()
        setupNavigationBar()
    }
    
    // MARK: - Private -
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
    
    private func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
            
            passwordTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: horizontalInset),
            passwordTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -horizontalInset),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            repeatPasswordTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: horizontalInset),
            repeatPasswordTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -horizontalInset),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            termsOfServiceContainer.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: horizontalInset),
            termsOfServiceContainer.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -horizontalInset),
            
            submitButton.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            submitButton.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension AuthViewController: AuthViewControllerProtocol {
    func showValidateFailure(with errorType: ValidationError) {
        let alert = UIAlertController(title: "Error", message: errorType.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
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

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextFieldReturning(textField)
    }
    
    private func handleTextFieldReturning(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
}
