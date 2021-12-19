//
//  AuthViewController.swift
//  Posts.demo
//
//  Created by devmac on 13.12.2021.
//

import UIKit

protocol SignUpViewControllerProtocol: AnyObject {
    func termsOfServiceStateChanged(_ value: Bool)
    func showValidationError(with errorType: ValidationError)
}

class SignUpViewController: UIViewController {
    
    var presenter: SignUpPresenter!
    
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
        label.font = UIFont.applicatonFont(.regular, size: 26)
        label.textColor = .black
        return label
    }()
    
    private lazy var loginTextField: FormTextField = {
        let field = FormTextField(placeholder: "Имя пользователя",
                                  isSecured: false)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        return field
    }()
    
    private lazy var passwordTextField: FormTextField = {
        let field = FormTextField(placeholder: "Пароль",
                                  isSecured: true)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        return field
    }()
    
    private lazy var passwordConfirmationTextField: FormTextField = {
        let field = FormTextField(placeholder: "Повторите пароль",
                                  isSecured: true)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        return field
    }()
    
    private lazy var termsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Прочитал(а) "
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.font = UIFont.applicatonFont()
        return label
    }()
    
    private lazy var termsOfServiceSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.addAction(UIAction { [weak self] _ in
            self?.presenter.termsOfServiceStateChanged(self?.termsOfServiceSwitcher.isOn ?? false)
        }, for: .valueChanged)
        return switcher
    }()
    
    private lazy var termsOfServiceButton: UIButton = {
        let button = UIButton()
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font:  UIFont.applicatonFont(),
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
            string: "Условия пользования",
            attributes: yourAttributes
        )
        button.setAttributedTitle(attributeString, for: .normal)
        button.addAction(UIAction { [unowned self] _ in
            self.presenter.termsOfServiceButtonClicked()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var termsOfServiceContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        
        return stack
    }()
    
    private lazy var alreadyHaveAccount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Уже есть аккаунт?"
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.applicatonFont()
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.applicatonFont()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Войти в аккаунт", for: .normal)
        button.addAction(UIAction { [unowned self] _ in
            self.presenter.navigateToLogin()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.addAction(UIAction { _ in
            self.presenter.submitButtonClicked()
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
        setupStackViewLayout()
    }
    
    private func setupSuperviewColor() {
        view.backgroundColor = .white
    }
    
    private func arrangeSubview() {
        stackView.addArrangedSubview(signUpLabel)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordConfirmationTextField)
        stackView.addArrangedSubview(termsOfServiceContainer)
        termsOfServiceContainer.addArrangedSubview(termsOfServiceSwitcher)
        termsOfServiceContainer.addArrangedSubview(termsOfServiceLabel)
        termsOfServiceContainer.addArrangedSubview(termsOfServiceButton)
        stackView.addArrangedSubview(alreadyHaveAccount)
        stackView.addArrangedSubview(loginButton)
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
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -horizontalInset),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupConstraints() {
        // let screenWidth: CGFloat = UIScreen.main.bounds.width
        let formItemHeight: CGFloat = 40
        let horizontalInset: CGFloat = 32
        NSLayoutConstraint.activate([
            signUpLabel.heightAnchor.constraint(equalToConstant: formItemHeight),
            
            loginTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor,
                                                 constant: horizontalInset),
            loginTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor,
                                                  constant: -horizontalInset),
            loginTextField.heightAnchor.constraint(equalToConstant: formItemHeight),
            
            passwordTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor,
                                                    constant: horizontalInset),
            passwordTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor,
                                                     constant: -horizontalInset),
            passwordTextField.heightAnchor.constraint(equalToConstant: formItemHeight),
            
            passwordConfirmationTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor,
                                                          constant: horizontalInset),
            passwordConfirmationTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor,
                                                           constant: -horizontalInset),
            passwordConfirmationTextField.heightAnchor.constraint(equalToConstant: formItemHeight),
            
            termsOfServiceContainer.leftAnchor.constraint(equalTo: stackView.leftAnchor,
                                                          constant: horizontalInset),
            termsOfServiceContainer.rightAnchor.constraint(equalTo: stackView.rightAnchor,
                                                           constant: -horizontalInset),
            
            submitButton.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            submitButton.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: formItemHeight)
        ])
    }
}

extension SignUpViewController: SignUpViewControllerProtocol {
    func showValidationError(with errorType: ValidationError) {
        let alert = UIAlertController(title: "Error",
                                      message: errorType.message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                               comment: "Default action"),
                                      style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func termsOfServiceStateChanged(_ value: Bool) {
        submitButton.isEnabled = value
        submitButton.backgroundColor = value ? .black : .lightGray
        termsOfServiceLabel.textColor = value ? .black : .lightGray
        print("state -> \(value)")
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case loginTextField:
            presenter.loginTextFieldDidChange(textField.text ?? "")
        case passwordTextField:
            presenter.passwordTextFieldDidChange(textField.text ?? "")
        case passwordConfirmationTextField:
            presenter.passwordConfirmationTextFieldDidChange(textField.text ?? "")
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextFieldReturning(textField)
    }
    
    private func handleTextFieldReturning(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
}
