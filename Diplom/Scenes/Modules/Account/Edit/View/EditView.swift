//
//  EditView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit
import SnapKit

protocol EditViewDelegat: AnyObject {
    func didTapBackButton()
    func editButtonTapped(name: UITextField,
                                  number: UITextField,
                                  city: UITextField)
}

final class EditView: UIView {
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "Редактировать"
        view.basketButton.removeFromSuperview()
        view.backgroundColor = .systemBlue
        return view
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
    
    lazy var editButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Редактировать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: EditViewDelegat?
    weak var textFieldDelegat: TextFieldDelegate?
    
    required init(delegate: EditViewDelegat, textFieldDelegat: TextFieldDelegate) {
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
        numberTextField.delegate = textFieldDelegat
    }
    
    func setupElements(){
        
        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        backgroundColor = UIColor.white

    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(fullnameTextField)
        addSubview(numberTextField)
        addSubview(cityTextField)
        addSubview(editButton)
    }
    
    func configure(user: User) {
        fullnameTextField.text = user.name
        cityTextField.text = user.city
        numberTextField.text = user.phone
    }
    
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        fullnameTextField.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-20)
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
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(cityTextField.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
    }
    
    @objc
    func editButtonTapped() {
        delegate?.editButtonTapped(name: self.fullnameTextField,
                                   number: self.numberTextField,
                                   city: self.cityTextField)
    }
    
    @objc
    func didTapBackButton() {
        delegate?.didTapBackButton()
    }
}

