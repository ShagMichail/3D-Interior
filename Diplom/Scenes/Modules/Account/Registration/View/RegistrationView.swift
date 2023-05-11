//
//  File.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit
import SnapKit

protocol GoToRegistration: AnyObject {
    func didTapBackButton()
    func registrationButtonTapped(name: UITextField,
                                  email: UITextField,
                                  password: UITextField,
                                  number: UITextField,
                                  city: UITextField)
    func loginButtonTapped()
}

final class RegistrationView: UIView {
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "Вход в аккаунт"
        view.basketButton.removeFromSuperview()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var singUpLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    lazy var numberTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Phone")
        tf.returnKeyType = .done
        tf.textContentType = .telephoneNumber
        tf.keyboardType = .numberPad
        tf.keyboardAppearance = .light
        tf.addDoneCanselToolBar()
        return tf
    }()
    
    lazy var cityTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "City")
        tf.returnKeyType = .done
        tf.textContentType = .addressCity
        tf.keyboardAppearance = .light
        return tf
    }()
    
    lazy var fullnameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Fullname")
        tf.returnKeyType = .done
        tf.textContentType = .name
        tf.keyboardAppearance = .light
        return tf
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
        tf.isSecureTextEntry = true
        tf.keyboardAppearance = .light
        return tf
    }()
    
    lazy var signUpButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemBlue, .font: UIFont.boldSystemFont(ofSize: 16)]
        
        let attriburedTitle = NSMutableAttributedString(string: "Войти",
                                                        attributes: atts)
        
        button.setAttributedTitle(attriburedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    weak var delegate: GoToRegistration?
    weak var textFieldDelegat: TextFieldDelegate?
    
    required init(delegate: GoToRegistration, textFieldDelegat: TextFieldDelegate) {
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
        cityTextField.delegate = textFieldDelegat
        fullnameTextField.delegate = textFieldDelegat
        passwordTextFiel.delegate = textFieldDelegat
        numberTextField.delegate = textFieldDelegat
        emailTextField.delegate = textFieldDelegat
    }
    
    func setupElements(){
        
        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        backgroundColor = UIColor.white
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "StringWithUnderLine", attributes: underlineAttribute)
        singUpLabel.font = UIFont.boldSystemFont(ofSize: 16)
        singUpLabel.textColor = UIColor.systemBlue
        singUpLabel.attributedText = underlineAttributedString
        singUpLabel.text = "Регистрация"
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(singUpLabel)
        addSubview(loginButton)
        addSubview(emailTextField)
        addSubview(passwordTextFiel)
        addSubview(fullnameTextField)
        addSubview(numberTextField)
        addSubview(cityTextField)
        addSubview(signUpButton)
    }
    
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-20)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        singUpLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-20)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        fullnameTextField.snp.makeConstraints {
            $0.top.equalTo(singUpLabel.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        numberTextField.snp.makeConstraints {
            $0.top.equalTo(fullnameTextField.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        cityTextField.snp.makeConstraints {
            $0.top.equalTo(numberTextField.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(cityTextField.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        passwordTextFiel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextFiel.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
    }
    
    @objc
    func registrationButtonTapped() {
        delegate?.registrationButtonTapped(name: self.fullnameTextField,
                                          email: self.emailTextField,
                                          password: self.passwordTextFiel,
                                          number: self.numberTextField,
                                          city: self.cityTextField)
    }
    
    @objc
    func didTapBackButton() {
        delegate?.didTapBackButton()
    }
    
    @objc
    func loginButtonTapped() {
        delegate?.loginButtonTapped()
    }
    
}
