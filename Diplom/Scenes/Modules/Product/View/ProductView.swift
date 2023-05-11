//
//  ProductView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 26.01.2023.
//

import UIKit
import SnapKit

protocol ProductViewDelegate: AnyObject {
    func didTapBackButton()
    func didTapModelButton()
//    func didTapBuyButton()
    func didTapBasketButton()
}

final class ProductView: UIView {
    
    weak var delegate: ProductViewDelegate?
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    
    lazy var productImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.layer.cornerRadius = 6
        imageView.sizeToFit()
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    //MARK: - название
    
    lazy var nameDefaultLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.tintColor = .systemGray3
        label.text = "Название:"
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var nameContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 5
        return view
    }()
    
    //MARK: - цена
    
    lazy var costDefaultLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.tintColor = .systemGray3
        label.text = "Стоимость:"
        return label
    }()
    
    lazy var costLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var costContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 5
        return view
    }()
    
    //MARK: - размеры
    
    lazy var sizeDefaultLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.tintColor = .systemGray3
        label.text = "Размеры:"
        return label
    }()
    
    lazy var sizeLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var sizeContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 5
        return view
    }()
    
    //MARK: - описание
    
    lazy var descriptionDefaultLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.tintColor = .systemGray3
        label.text = "Описание:"
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var modelLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "Чуть позже появится модель"
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var modelButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Примерить", for: .normal)
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
    
    lazy var buyButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Купить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.backgroundColor = .systemBlue
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.cornerRadius = 20
    
        return button
    }()
    
    required init(delegate: ProductViewDelegate) {
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
        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        headerView.basketButton.addTarget(self, action: #selector(didTapBasketButton), for: .touchUpInside)
        modelButton.addTarget(self, action: #selector(didTapModelButton), for: .touchUpInside)
    }
    
    func configure(with data: Product) {
        nameLabel.text = data.name
        costLabel.text = data.cost
        sizeLabel.text = data.size
        descriptionLabel.text = data.description
        if data.nameModel == "" {
            modelButton.isHidden = true
            modelLabel.isHidden = false
        } else {
            modelButton.isHidden = false
            modelLabel.isHidden = true
        }
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(productImage)
        addSubview(nameContainerView)
        nameContainerView.addSubview(nameDefaultLabel)
        nameContainerView.addSubview(nameLabel)
        addSubview(costContainerView)
        costContainerView.addSubview(costDefaultLabel)
        costContainerView.addSubview(costLabel)
        addSubview(sizeContainerView)
        sizeContainerView.addSubview(sizeDefaultLabel)
        sizeContainerView.addSubview(sizeLabel)
        addSubview(descriptionContainerView)
        descriptionContainerView.addSubview(descriptionDefaultLabel)
        descriptionContainerView.addSubview(descriptionLabel)
        addSubview(modelButton)
        addSubview(buyButton)
        addSubview(modelLabel)
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        productImage.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-15)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(300)
        }
        
        nameContainerView.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            $0.top.equalTo(productImage.snp.bottom).inset(-15)
            $0.bottom.equalTo(nameLabel.snp.bottom).inset(-10)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 40)
        }
        
        nameDefaultLabel.snp.makeConstraints {
            $0.leading.equalTo(nameContainerView.snp.leading).inset(10)
            //$0.trailing.equalTo(nameContainerView.snp.trailing).inset(-10)
            $0.top.equalTo(nameContainerView.snp.top).inset(10)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(nameContainerView.snp.leading).inset(10)
           //$0.trailing.equalTo(nameContainerView.snp.trailing).inset(-10)
            $0.top.equalTo(nameDefaultLabel.snp.bottom).inset(-3)
        }
        
        sizeContainerView.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.top.equalTo(productImage.snp.bottom).inset(-15)
            $0.bottom.equalTo(sizeLabel.snp.bottom).inset(-10)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 40)
        }
        
        sizeDefaultLabel.snp.makeConstraints {
            $0.leading.equalTo(sizeContainerView.snp.leading).inset(10)
            //$0.trailing.equalTo(sizeContainerView.snp.trailing).inset(-10)
            $0.top.equalTo(sizeContainerView.snp.top).inset(10)
        }
        
        sizeLabel.snp.makeConstraints {
            $0.leading.equalTo(sizeContainerView.snp.leading).inset(10)
            //$0.trailing.equalTo(sizeContainerView.snp.trailing).inset(-10)
            $0.top.equalTo(sizeDefaultLabel.snp.bottom).inset(-3)
        }
        
        costContainerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.top.equalTo(sizeContainerView.snp.bottom).inset(-15)
            $0.bottom.equalTo(costLabel.snp.bottom).inset(-10)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 40)
        }
        
        costDefaultLabel.snp.makeConstraints {
            $0.leading.equalTo(costContainerView.snp.leading).inset(10)
            //$0.trailing.equalTo(costContainerView.snp.trailing).inset(-10)
            $0.top.equalTo(costContainerView.snp.top).inset(10)
            
        }
        
        costLabel.snp.makeConstraints {
            $0.leading.equalTo(costContainerView.snp.leading).inset(10)
            $0.top.equalTo(costDefaultLabel.snp.bottom).inset(-3)
        }
        
        descriptionContainerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.top.equalTo(costContainerView.snp.bottom).inset(-15)
            $0.bottom.equalTo(descriptionLabel.snp.bottom).inset(-10)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 40)
        }
        
        descriptionDefaultLabel.snp.makeConstraints {
            $0.leading.equalTo(descriptionContainerView.snp.leading).inset(10)
            $0.trailing.equalTo(descriptionContainerView.snp.trailing).inset(-10)
            $0.top.equalTo(descriptionContainerView.snp.top).inset(10)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(descriptionContainerView.snp.leading).inset(10)
            $0.trailing.equalTo(descriptionContainerView.snp.trailing).inset(10)
            $0.top.equalTo(descriptionDefaultLabel.snp.bottom).inset(-3)
            //$0.bottom.equalTo(descriptionContainerView.snp.bottom).inset(-10)
            
        }
        
        modelButton.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            $0.trailing.equalTo(buyButton.snp.leading).inset(-10)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 40)
        }
        
        modelLabel.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            $0.trailing.equalTo(buyButton.snp.leading).inset(-10)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 40)
        }
        
        buyButton.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.leading.equalTo(modelButton.snp.trailing).inset(-10)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30).priority(.low)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 40)
        }
        
    }
    
    @objc func didTapBackButton() {
        delegate?.didTapBackButton()
    }
    
    @objc func didTapModelButton() {
        delegate?.didTapModelButton()
    }
    
    @objc func didTapBuyButton() {
//        delegate?.didTapBuyButton()
    }
    
    @objc func didTapBasketButton() {
        delegate?.didTapBasketButton()
    }
}
