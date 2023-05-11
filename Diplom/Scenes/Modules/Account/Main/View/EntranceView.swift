//
//  EntraceView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 26.01.2023.
//

import UIKit
import SnapKit

protocol EntranceViewProtocol: AnyObject {
    func didTapButton()
}

final class EntranceView: UIView {
    
    weak var delegate: EntranceViewProtocol?
    
    lazy var entranceImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "person.text.rectangle")
       
        return image
    }()
    
    lazy var entranceButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 20
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
        
    lazy var entranceLabel: UILabel = {
        var label = UILabel()
        label.text = "Войдите в профиль"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "После входа вы сможете оформлять заказы и совершать покупки"
        label.textAlignment = .center
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
    
    private func addSubviews() {
        addSubview(entranceImage)
        addSubview(entranceLabel)
        addSubview(descriptionLabel)
        addSubview(entranceButton)
        
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        entranceImage.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(15)
            $0.centerX.equalTo(self)
            $0.height.equalTo(120)
            $0.width.equalTo(160)
        }
        
        entranceLabel.snp.makeConstraints {
            $0.top.equalTo(entranceImage.snp.bottom).inset(-15)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(entranceLabel.snp.bottom).inset(-5)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        entranceButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).inset(-20)
            $0.centerX.equalTo(self)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
    
    @objc
    func didTapButton() {
        delegate?.didTapButton()
    }

}
