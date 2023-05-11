//
//  ResultCell.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 23.02.2023.
//

import UIKit
import SnapKit

final class ResultCell: UIView {
        
    lazy var numberPositionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var totalCostLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
//
//    lazy var codeProduct: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 2
//        label.font = UIFont.italicSystemFont(ofSize: 20)
//        label.textAlignment = .center
//        return label
//    }()
//
//    lazy var costProduct: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 2
//        label.font = UIFont.italicSystemFont(ofSize: 15)
//        label.textAlignment = .center
//        return label
//    }()
//
//    lazy var countProduct: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 2
//        label.font = UIFont.italicSystemFont(ofSize: 15)
//        label.textAlignment = .center
//        return label
//    }()
//
//    lazy var totalCostProduct: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 2
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.textAlignment = .center
//        return label
//    }()
    
    private var totlaPosition = 0
    private var totlaCost = 0
    
    required init(product: [ProductBasket]) {
        super.init(frame: .zero)
        backgroundColor = .systemBlue
        addSubviews()
        makeConstraints()
        configure(product: product)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(numberPositionsLabel)
        addSubview(totalCostLabel)
//        addSubview(costProduct)
//        addSubview(countProduct)
//        addSubview(codeProduct)
//        addSubview(totalCostProduct)
    }
    
    func configure(product: [ProductBasket]) {
        product.forEach { product in
            totlaPosition += product.count
            totlaCost += (Int(product.product.cost) ?? 0)*product.count
        }
        numberPositionsLabel.text = "Всего товаров: \(totlaPosition)"
        totalCostLabel.text = "К оплате: \(totlaCost)"
//        countProduct.text = "В заказе: \(product.count) шт."
//        codeProduct.text = product.product.code
//        totalCostProduct.text = "Общая сумма: \(product.product.cost) * \(product.count) = \((Int(product.product.cost) ?? 0)*product.count)"
//        sequenceNumberLabel.text = "\(sequenceNumber)."
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        
        numberPositionsLabel.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(10)
            $0.top.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        totalCostLabel.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
            $0.top.equalTo(numberPositionsLabel.snp.bottom).inset(-5)
        }
//        codeProduct.snp.makeConstraints {
//            $0.top.equalTo(safeAreaLayoutGuide).inset(15)
//            $0.trailing.equalTo(safeAreaLayoutGuide).inset(15)
//        }
//        countProduct.snp.makeConstraints {
//            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
//            $0.top.equalTo(nameProduct.snp.bottom).inset(-5)
//        }
//        costProduct.snp.makeConstraints {
//            $0.top.equalTo(countProduct.snp.bottom).inset(-5)
//            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
//        }
//        totalCostProduct.snp.makeConstraints {
//            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
//            $0.top.equalTo(costProduct.snp.bottom).inset(-5)
//        }
    }
}
