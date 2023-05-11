//
//  UserView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit
import SnapKit

protocol UserViewProtocol: AnyObject {
    func didTapBasketButton()
    func didTapExitButton()
    func didTapEditButton()
}

final class UserView: UIView {
    
    weak var delegate: UserViewProtocol?
    
    lazy var userImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "person.text.rectangle")
       
        return image
    }()
    
    lazy var basketButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 20
        button.setTitle("Корзина", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.addTarget(self, action: #selector(didTapBasketButton), for: .touchUpInside)
        return button
    }()
    
    lazy var exitButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 20
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        return button
    }()
    
    lazy var editButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 20
        button.setTitle("Профиль", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return button
    }()
        
    lazy var userLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var countBuyLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    lazy var countProcessingLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    required init() {
        super.init(frame: .zero)
        
        setupElement()
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
        backgroundColor = .white
    }
    
    func configure(user: User) {
        userImage.image = UIImage(systemName: "person.fill.checkmark")
        userLabel.text = user.name
        countBuyLabel.text = "Заказов оформленно: \(user.countBuy)"
        countProcessingLabel.text = "Заказов в обработке: \(user.countProcessing)"
    }
    
    private func addSubviews() {
        addSubview(userImage)
        addSubview(userLabel)
        addSubview(countBuyLabel)
        addSubview(countProcessingLabel)
        addSubview(basketButton)
        addSubview(exitButton)
        addSubview(editButton)
        
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        editButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(15)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
        
        exitButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(15)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(15)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
        
        userImage.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).inset(-15)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(60)
            $0.width.equalTo(80)
        }
        
        userLabel.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).inset(-38)
            $0.leading.equalTo(userImage.snp.trailing).inset(-10)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(15)

        }
        
        countBuyLabel.snp.makeConstraints {
            $0.top.equalTo(userImage.snp.bottom).inset(-25)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        countProcessingLabel.snp.makeConstraints {
            $0.top.equalTo(countBuyLabel.snp.bottom).inset(-10)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        basketButton.snp.makeConstraints {
            $0.top.equalTo(countProcessingLabel.snp.bottom).inset(-20)
            $0.centerX.equalTo(self)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
    
    @objc
    func didTapBasketButton() {
        delegate?.didTapBasketButton()
    }
    
    @objc
    func didTapExitButton() {
        delegate?.didTapExitButton()
    }
    
    @objc
    func didTapEditButton() {
        delegate?.didTapEditButton()
    }
}

