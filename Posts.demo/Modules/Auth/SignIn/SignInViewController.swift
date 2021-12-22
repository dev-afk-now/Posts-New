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
    
    // MARK: - Private properties -
    
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
        label.font = .applicatonFont(size: 26)
        label.textColor = .black
        return label
    }()
    
    private lazy var loginTextField: FormTextField = {
        let field = FormTextField(type: .username)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        return field
    }()
    
    private lazy var passwordTextField: FormTextField = {
        let field = FormTextField(type: .password)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        return field
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.addTarget(self,
                         action: #selector(submitButtonClicked),
                         for: .touchUpInside)
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
        label.font = .applicatonFont()
        return label
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .applicatonFont()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.presenter.navigateToRegistration()
        }, for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupConstraints()
        setupNavigationBar()
    }
    
    // MARK: - Private methods -
    
    private func setupMainViewBackground() {
        view.backgroundColor = .white
    }
    
    private func initialSetup() {
        setupMainViewBackground()
        setupStackViewLayout()
        arrangeStack()
    }
    
    private func setupSuperviewBackground() {
        view.backgroundColor = .white
    }
    
    private func arrangeStack() {
        stackView.addArrangedSubview(signInLabel)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(dontHaveAccountLabel)
        stackView.addArrangedSubview(registrationButton)
        stackView.addArrangedSubview(submitButton)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false,
                                                          animated: false)
    }
    
    private func setupStackViewLayout() {
        let horizontalInset: CGFloat = 10
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                            constant: horizontalInset),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                             constant: -horizontalInset),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupConstraints() {
        let itemHeight: CGFloat = 40
        let horizontalInset: CGFloat = 32
        NSLayoutConstraint.activate([
            signInLabel.heightAnchor.constraint(equalToConstant: itemHeight),
            
            loginTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor,
                                                 constant: horizontalInset),
            loginTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor,
                                                  constant: -horizontalInset),
            loginTextField.heightAnchor.constraint(equalToConstant: itemHeight),
            
            passwordTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor,
                                                    constant: horizontalInset),
            passwordTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor,
                                                     constant: -horizontalInset),
            passwordTextField.heightAnchor.constraint(equalToConstant: itemHeight),
            registrationButton.heightAnchor.constraint(equalToConstant: itemHeight),
            
            submitButton.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            submitButton.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
    }
    
    // MARK: - Actions -
    
    @objc private func submitButtonClicked() {
        view.endEditing(true)
        presenter.validateAndSignIn()
    }
}

// MARK: - SignInViewController Extension -

extension SignInViewController: SignInViewControllerProtocol {
    func showValidationError(with errorType: ValidationError) {
        self.showAlert(with: errorType.message)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextFieldReturning(textField)
    }
    
    private func handleTextFieldReturning(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let field = textField as? FormTextField {
            presenter.updateUserForm(text: field.text ?? "",
                                     type: field.internalType)
        }
    }
}
