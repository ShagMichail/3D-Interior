//
//  ContactView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 26.01.2023.
//

import UIKit
import SnapKit

protocol ContactViewDelegate: AnyObject {
    func didTapButton()
}

final class ContactView: UIView {
    
    weak var delegate: ContactViewDelegate?
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "Контакты"
        view.backButton.removeFromSuperview()
        view.basketButton.removeFromSuperview()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var infoPhoneLabel: UILabel = {
        var label = UILabel()
        label.text = "Телефон:"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        var label = UILabel()
        label.text = "+7-(909)-333-44-55"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var infoEmailLabel: UILabel = {
        var label = UILabel()
        label.text = "Почта:"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        var label = UILabel()
        label.text = "ffffffff@mail.ru"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var infoAdressLabel: UILabel = {
        var label = UILabel()
        label.text = "Юридический адрес:"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var adressLabel: UILabel = {
        var label = UILabel()
        label.text = "город Москва, академика Бакулева, дом 10"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var phoneButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Позвонить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.cornerRadius = 20
    
        return button
    }()
    
    required init(delegate: ContactViewDelegate) {
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
        setupElement()
        
        self.delegate = delegate
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
        phoneButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(infoAdressLabel)
        addSubview(adressLabel)
        addSubview(infoPhoneLabel)
        addSubview(phoneLabel)
        addSubview(infoEmailLabel)
        addSubview(emailLabel)
        addSubview(phoneButton)
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }
        
        infoAdressLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-30)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        adressLabel.snp.makeConstraints {
            $0.top.equalTo(infoAdressLabel.snp.bottom).inset(-5)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        infoEmailLabel.snp.makeConstraints {
            $0.top.equalTo(adressLabel.snp.bottom).inset(-10)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(infoEmailLabel.snp.bottom).inset(-5)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        infoPhoneLabel.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).inset(-10)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        phoneLabel.snp.makeConstraints {
            $0.top.equalTo(infoPhoneLabel.snp.bottom).inset(-5)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        phoneButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(50)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
    }
    
    @objc func didTapButton() {
        delegate?.didTapButton()
    }
}

