//
//  ScrollCell.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit
import SnapKit

final class ScrollCell: UIView {
        
    lazy var sequenceNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var nameProduct: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var codeProduct: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var costProduct: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()

    lazy var countProduct: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    lazy var totalCostProduct: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    required init(product: ProductBasket, sequenceNumber: Int) {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews()
        makeConstraints()
        configure(product: product, sequenceNumber: sequenceNumber)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(sequenceNumberLabel)
        addSubview(nameProduct)
        addSubview(costProduct)
        addSubview(countProduct)
        addSubview(codeProduct)
        addSubview(totalCostProduct)
    }
    
    func configure(product: ProductBasket, sequenceNumber: Int) {
        nameProduct.text = product.product.name
        costProduct.text = "Стоимость за шт.: \(product.product.cost)"
        countProduct.text = "В заказе: \(product.count) шт."
        codeProduct.text = product.product.code
        totalCostProduct.text = "Общая сумма: \(product.product.cost) * \(product.count) = \((Int(product.product.cost) ?? 0)*product.count)"
        sequenceNumberLabel.text = "\(sequenceNumber)."
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        
        sequenceNumberLabel.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
            $0.top.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        nameProduct.snp.makeConstraints {
            $0.leading.equalTo(sequenceNumberLabel.snp.trailing).inset(-7)
            $0.top.equalTo(safeAreaLayoutGuide).inset(15)
        }
        codeProduct.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(15)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(15)
        }
        countProduct.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
            $0.top.equalTo(nameProduct.snp.bottom).inset(-5)
        }
        costProduct.snp.makeConstraints {
            $0.top.equalTo(countProduct.snp.bottom).inset(-5)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
        }
        totalCostProduct.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(15)
            $0.top.equalTo(costProduct.snp.bottom).inset(-5)
        }
    }
}


