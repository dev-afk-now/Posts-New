//
//  SignInViewController.swift
//  Posts.demo
//
//  Created by devmac on 16.12.2021.
//

import UIKit

protocol SignInViewControllerProtocol: AnyObject {
    func showValidationError(with errorType: ValidationError)
}

class SignInViewController: UIViewController {
    
    var presenter: SignInPresenter!
    
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
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Вход"
        label.font = UIFont.applicatonFont(.regular, size: 26)
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
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.addAction(UIAction { [unowned self] _ in
            self.presenter.submitButtonClicked()
        }, for: .touchUpInside)
        button.backgroundColor = .black
        return button
    }()
    
    private lazy var dontHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нет аккаунта?"
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.applicatonFont()
        return label
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.applicatonFont()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.addAction(UIAction { [unowned self] _ in
            self.presenter.navigateToRegistration()
        }, for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupConstraints()
        setupNavigationBar()
    }
    
    // MARK: - Private funcs -
    
    private func initialSetup() {
        view.backgroundColor = .white
        setupStackViewLayout()
        stackView.addArrangedSubview(signInLabel)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(dontHaveAccountLabel)
        stackView.addArrangedSubview(registrationButton)
        stackView.addArrangedSubview(submitButton)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupStackViewLayout() {
        view.addSubview(stackView)
        let horizontalInset: CGFloat = 10
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: horizontalInset),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: horizontalInset),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupConstraints() {
        let horizontalInset: CGFloat = 32
        let formItemHeight: CGFloat = 40
        NSLayoutConstraint.activate([
            signInLabel.heightAnchor.constraint(equalToConstant: formItemHeight),
            
            loginTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor,
                                                 constant: horizontalInset),
            loginTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor,
                                                  constant: -horizontalInset),
            loginTextField.heightAnchor.constraint(equalToConstant: formItemHeight),
            
            passwordTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor,
                                                    constant: horizontalInset),
            passwordTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -horizontalInset),
            passwordTextField.heightAnchor.constraint(equalToConstant: formItemHeight),
            registrationButton.heightAnchor.constraint(equalToConstant: formItemHeight),
            
            submitButton.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            submitButton.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: formItemHeight)
        ])
    }
}

// MARK: - SignInViewController Extension -

extension SignInViewController: SignInViewControllerProtocol {
    func showValidationError(with errorType: ValidationError) {
        let alert = UIAlertController(title: "Error", message: errorType.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextFieldReturning(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case loginTextField:
            presenter.loginTextFieldDidChange(textField.text ?? "")
        case passwordTextField:
            presenter.passwordTextFieldDidChange(textField.text ?? "")
        default:
            break
        }
    }
    
    private func handleTextFieldReturning(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
}

