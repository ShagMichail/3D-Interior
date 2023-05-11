//
//  ResetPaswordView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit
import SnapKit

protocol ResetPasswordDelegat: AnyObject {
    func didTapBackButton()
    func resetButtonTapped(email: UITextField)
}

final class ResetPasswordView: UIView {
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "Вход в аккаунт"
        view.basketButton.removeFromSuperview()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "key.fill")
        image.tintColor = UIColor.black
        return image
    }()
    
    lazy var resetLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите почту, на которую зарегистрирован аккаунт"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
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
    
    lazy var resetButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Отправить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
        
    weak var delegate: ResetPasswordDelegat?
    weak var textFieldDelegat: TextFieldDelegate?
    
    required init(delegate: ResetPasswordDelegat, textFieldDelegat: TextFieldDelegate) {
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
        emailTextField.delegate = textFieldDelegat
    }
    
    func setupElements(){

        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        backgroundColor = UIColor.white
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(resetLabel)
        addSubview(emailTextField)
        addSubview(resetButton)
        addSubview(image)
    }
    
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        image.snp.makeConstraints {
            $0.bottom.equalTo(0)
            $0.leading.equalTo(0)
            $0.width.equalTo(UIScreen.main.bounds.width/2)
            $0.height.equalTo(UIScreen.main.bounds.height/3)
        }
        
        resetLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-100)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(resetLabel.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }

        resetButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
    }
    
    @objc
    func didTapBackButton() {
        delegate?.didTapBackButton()
    }
    
    @objc
    func resetButtonTapped() {
        delegate?.resetButtonTapped(email: self.emailTextField)
    }
    
}

