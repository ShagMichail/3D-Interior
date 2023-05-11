//
//  LoginView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit
import SnapKit

protocol GoToLogin: AnyObject {
    func didTapBackButton()
    func loginButtonTapped(email: UITextField, password: UITextField)
    func registrirtButtonTapped()
    func resetButtonTapped()
}


final class LoginView: UIView {
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "Вход в аккаунт"
        view.basketButton.removeFromSuperview()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var logInLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    lazy var emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "email")
        tf.returnKeyType = .done
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        tf.keyboardAppearance = .light
        return tf
    }()
    
    lazy var passwordTextFiel: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.returnKeyType = .done
        tf.textContentType = .password
        tf.keyboardAppearance = .light
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemBlue, .font: UIFont.systemFont(ofSize: 15)]
        
        let attriburedTitle = NSMutableAttributedString(string: "Забыли свой пароль? ",
                                                        attributes: atts)
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemBlue, .font: UIFont.boldSystemFont(ofSize: 15)]
        attriburedTitle.append(NSAttributedString(string: "Поменяйте.", attributes: boldAtts))
        
        button.setAttributedTitle(attriburedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var dividerView = DividerView()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemBlue, .font: UIFont.boldSystemFont(ofSize: 16)]
        
        let attriburedTitle = NSMutableAttributedString(string: "Регистрация",
                                                        attributes: atts)
        
        button.setAttributedTitle(attriburedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(registrirtButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    weak var delegate: GoToLogin?
    weak var textFieldDelegat: TextFieldDelegate?
    
    required init(delegate: GoToLogin, textFieldDelegat: TextFieldDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.textFieldDelegat = textFieldDelegat
        self.backgroundColor = .white

        addSubviews()
        setupDelegate()
        setupElements()
        
    }
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeConstraints()
    }
    
    func setupDelegate(){
        passwordTextFiel.delegate = textFieldDelegat
        emailTextField.delegate = textFieldDelegat
    }
    
    func setupElements(){

        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        backgroundColor = UIColor.white

        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "StringWithUnderLine", attributes: underlineAttribute)
        logInLabel.font = UIFont.boldSystemFont(ofSize: 16)
        logInLabel.textColor = UIColor.systemBlue
        logInLabel.attributedText = underlineAttributedString
        logInLabel.text = "Войти"
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(logInLabel)
        addSubview(signUpButton)
        addSubview(emailTextField)
        addSubview(passwordTextFiel)
        addSubview(loginButton)
        addSubview(forgotPasswordButton)
        addSubview(dividerView)
    }
    
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        logInLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-20)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-20)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        passwordTextFiel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextFiel.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).inset(-30)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
    }
    
    @objc
    func loginButtonTapped() {
        delegate?.loginButtonTapped(email: self.emailTextField, password: self.passwordTextFiel)
    }
    
    @objc
    func didTapBackButton() {
        delegate?.didTapBackButton()
    }
    
    @objc
    func registrirtButtonTapped() {
        delegate?.registrirtButtonTapped()
    }
    
    @objc
    func resetButtonTapped() {
        delegate?.resetButtonTapped()
    }
}
