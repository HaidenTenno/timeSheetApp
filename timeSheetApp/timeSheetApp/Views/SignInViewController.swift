//
//  SignInViewController.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 02.04.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    // UI
    private var globalStackView: UIStackView!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var signInButton: UIButton!
    
    // Services
    private var networkService: NetworkService = NetworkServiceImplementation.shared
    
    // Callbacks
    private let onSignedIn: () -> Void
    
    // Public
    init(onSignedIn: @escaping () -> Void) {
        self.onSignedIn = onSignedIn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        networkService.delegate = self
    }
}

// MARK: - Private
private extension SignInViewController {
    
    private func setupGesture() {
        let gesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(gesture)
    }
        
    @objc private func onSignInButtonTouched() {
        guard let login = emailTextField.text, let password = passwordTextField.text else { return }
        LoadingIndicatorView.show()
        networkService.signIn(email: login, password: password)
    }
    
    private func onSignInErrorReceived() {
        let alertController = UIAlertController(title: "Ошибка", message: "Не удалось зайти в систему", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ясно", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UI
private extension SignInViewController {
    
    private func setupView() {
        // self
        view.backgroundColor = Design.Colors.blueColor
        
        // globalStackView
        globalStackView = UIStackView()
        globalStackView.alignment = .center
        globalStackView.axis = .vertical
        globalStackView.spacing = 20
        globalStackView.distribution = .fillEqually
        view.addSubview(globalStackView)
        
        // emailTextField
        emailTextField = UITextFieldPadding(top: 0, left: 10, bottom: 0, right: 10)
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.layer.cornerRadius = 20.0
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor = Design.Colors.greyColor.cgColor
        emailTextField.backgroundColor = .white
        emailTextField.textColor = Design.Colors.greyColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            NSAttributedString.Key.foregroundColor: Design.Colors.transparentGreyColor
        ])
        emailTextField.delegate = self
        globalStackView.addArrangedSubview(emailTextField)
        
        // passwordTextField
        passwordTextField = UITextFieldPadding(top: 0, left: 10, bottom: 0, right: 10)
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.layer.cornerRadius = 20.0
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.layer.borderColor = Design.Colors.greyColor.cgColor
        passwordTextField.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = Design.Colors.greyColor
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            NSAttributedString.Key.foregroundColor: Design.Colors.transparentGreyColor
        ])
        passwordTextField.delegate = self
        globalStackView.addArrangedSubview(passwordTextField)
        
        // signInButton
        signInButton = UIButton()
        signInButton.backgroundColor = Design.Colors.whiteColor
        signInButton.layer.cornerRadius = 20
        signInButton.layer.borderWidth = 2.0
        signInButton.layer.borderColor = Design.Colors.greyColor.cgColor
        signInButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 20,bottom: 10,right: 20)
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.setTitleColor(Design.Fonts.MiniHeader.color, for: .normal)
        signInButton.titleLabel?.font = Design.Fonts.MiniHeader.font
        signInButton.addTarget(self, action: #selector(onSignInButtonTouched), for: .touchUpInside)
        globalStackView.addArrangedSubview(signInButton)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        // globalStackView
        globalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        // emailTextField
        emailTextField.snp.makeConstraints { make in
            make.left.equalTo(globalStackView).offset(50)
            make.right.equalTo(globalStackView).offset(-50)
        }
        
        // passwordTextField
        passwordTextField.snp.makeConstraints { make in
            make.left.equalTo(globalStackView).offset(50)
            make.right.equalTo(globalStackView).offset(-50)
            make.height.equalTo(emailTextField)
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - NetworkServiceDelegate
extension SignInViewController: NetworkServiceDelegate {
    
    func networkServiceDidSignIn(_ networkService: NetworkService) {
        DispatchQueue.main.async { [unowned self] in
            LoadingIndicatorView.hide()
            self.onSignedIn()
        }
    }
    
    func networkService(_ networkService: NetworkService, failedWith error: NetworkServiceError) {
        DispatchQueue.main.async { [unowned self] in
            LoadingIndicatorView.hide()
            self.onSignInErrorReceived()
        }
    }
}
