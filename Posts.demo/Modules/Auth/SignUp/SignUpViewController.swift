//
//  AuthViewController.swift
//  Posts.demo
//
//  Created by devmac on 13.12.2021.
//

import UIKit

protocol SignUpViewControllerProtocol: AnyObject {
    func changeTermsOfServiceState(_ value: Bool)
    func showValidationError(with errorType: ValidationError)
}

class SignUpViewController: UIViewController {
    
    var presenter: SignUpPresenter!
    
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
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Регистрация"
        label.font = .applicatonFont(size: 26)
        label.textColor = .black
        return label
    }()
    
    private lazy var loginTextField: FormTextField = {
        let field = FormTextField(type: .username)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.attributedPlaceholder = NSAttributedString(
            string: "Имя пользователя",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        field.textColor = .black
        field.configureBorder(width: 0.5, with: .lightGray)
        field.delegate = self
        return field
    }()
    
    private lazy var passwordTextField: FormTextField = {
        let field = FormTextField(type: .password)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.attributedPlaceholder = NSAttributedString(
            string: "Пароль",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        field.textColor = .black
        field.configureBorder(width: 0.5, with: .lightGray)
        field.delegate = self
        return field
    }()
    
    private lazy var repeatPasswordTextField: FormTextField = {
        let field = FormTextField(type: .confirmPassword)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.attributedPlaceholder = NSAttributedString(
            string: "Подтвердите пароль",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        field.textColor = .black
        field.configureBorder(width: 0.5, with: .lightGray)
        field.delegate = self
        return field
    }()
    
    private lazy var termsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Прочитал(а) "
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.font = .applicatonFont()
        return label
    }()
    
    private lazy var termsOfServiceSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.addAction(UIAction { [unowned self] _ in
            self.presenter.termsOfServiceSwitchStateChanged(self.termsOfServiceSwitcher.isOn)
        }, for: .valueChanged)
        return switcher
    }()
    
    private lazy var termsOfServiceButton: UIButton = {
        let button = UIButton()
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.applicatonFont(),
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
            string: "Условия пользования",
            attributes: yourAttributes
        )
        button.setAttributedTitle(attributeString, for: .normal)
        button.addAction(UIAction { [unowned self] _ in
            self.presenter.openTermsOfService()
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
        label.font = .applicatonFont()
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .applicatonFont()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Войти в аккаунт", for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.presenter.navigateToLogin()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.addTarget(self,
                         action: #selector(submitButtonClicked),
                         for: .touchUpInside)
        button.isEnabled = false
        button.backgroundColor = .lightGray
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
    
    private func arrangeStack() {
        stackView.addArrangedSubview(signUpLabel)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(repeatPasswordTextField)
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
        let horizontalInset: CGFloat = 10
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: horizontalInset),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -horizontalInset),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupConstraints() {
        let itemHeight: CGFloat = 40
        let horizontalInset: CGFloat = 32
        NSLayoutConstraint.activate([
            signUpLabel.heightAnchor.constraint(equalToConstant: itemHeight),
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
            repeatPasswordTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor,
                                                          constant: horizontalInset),
            repeatPasswordTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor,
                                                           constant: -horizontalInset),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: itemHeight),
            
            termsOfServiceContainer.leftAnchor.constraint(equalTo: stackView.leftAnchor,
                                                          constant: horizontalInset),
            termsOfServiceContainer.rightAnchor.constraint(equalTo: stackView.rightAnchor,
                                                           constant: -horizontalInset),
            submitButton.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            submitButton.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
    }
    
    // MARK: - Actions -
    
    @objc private func submitButtonClicked() {
        view.endEditing(true)
        presenter.validateAndSignUp()
    }
}

extension SignUpViewController: SignUpViewControllerProtocol {
    func showValidationError(with errorType: ValidationError) {
        self.showAlert(with: errorType.message)
    }
    
    func changeTermsOfServiceState(_ value: Bool) {
        submitButton.isEnabled = value
        submitButton.backgroundColor = value ? .black : .lightGray
        termsOfServiceLabel.textColor = value ? .black : .lightGray
    }
}
extension SignUpViewController: UITextFieldDelegate {
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
