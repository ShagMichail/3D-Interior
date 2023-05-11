//
//  AccountView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 26.01.2023.
//

import UIKit
import SnapKit

protocol AccountViewDelegate: AnyObject {
    func didTapInfoButton()
    func didTapContactButton()
    func didTapBasketButton()
}

final class AccountView: UIView {
    
    weak var delegate: AccountViewDelegate?
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "Личный кабинет"
        view.backButton.removeFromSuperview()
        view.basketButton.removeFromSuperview()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var entranceView: EntranceView = {
        var view = EntranceView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var userView: UserView = {
        var view = UserView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var emailView: EmailView = {
        var view = EmailView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var infoButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("О нас", for: .normal)
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
    
    lazy var contactButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Контакты", for: .normal)
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
    
    
    required init(delegate: AccountViewDelegate) {
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
        infoButton.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
        contactButton.addTarget(self, action: #selector(didTapContactButton), for: .touchUpInside)
        headerView.basketButton.addTarget(self, action: #selector(didTapBasketButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(entranceView)
        addSubview(userView)
        addSubview(emailView)
        addSubview(infoButton)
        addSubview(contactButton)
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        entranceView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-30)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(300)
        }
        
        userView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-30)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(300)
        }
        
        emailView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-30)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(300)
        }
        
        
        infoButton.snp.makeConstraints {
            $0.top.equalTo(entranceView.snp.bottom).inset(-50)
            $0.top.equalTo(userView.snp.bottom).inset(-50).priority(.low)
            $0.top.equalTo(emailView.snp.bottom).inset(-50).priority(.low)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
        
        contactButton.snp.makeConstraints {
            $0.top.equalTo(infoButton.snp.bottom).inset(-15)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
    }
    
    @objc func didTapInfoButton() {
        delegate?.didTapInfoButton()
    }
    
    @objc func didTapContactButton() {
        delegate?.didTapContactButton()
    }
    
    @objc func didTapBasketButton() {
        delegate?.didTapBasketButton()
    }

}
