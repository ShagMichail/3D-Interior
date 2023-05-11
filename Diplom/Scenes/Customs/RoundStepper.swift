//
//  CustomButton.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 11.02.2023.
//

import UIKit

protocol StepperDelegate: AnyObject {
    func zeroProduct(indexPath: IndexPath?)
}

final class RoundStepper: UIControl {
    
    weak var delegate: StepperDelegate?
    var indexPath: IndexPath?
    private var isAdd = false
    
    private lazy var plusButton = stepperButton(color: viewData.color, text: "+", value: 1)
    private lazy var minusButton = stepperButton(color: viewData.color, text: "-", value: -1)
    
    var flagZero: Bool = false
    
    lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    struct ViewData {
        let color: UIColor
        let minimum: Double
        let maximum: Double
        let stepValue: Double
    }
    
    var value: Double = 0
    private let viewData: ViewData
    
    var productsArray: StoresProduct = ProductDataStore()
    
    required init(
        viewData: ViewData,
        productsArray: StoresProduct = ProductDataStore.shared
    ) {
        self.productsArray = productsArray
        self.viewData = viewData
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ newValue: Double) {
        updateValue(min(viewData.maximum, max(viewData.minimum, newValue)))
    }
    
    private func setup() {
        backgroundColor = .white
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        [minusButton, counterLabel, plusButton].forEach(container.addArrangedSubview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        plusButton.layer.cornerRadius = 0.2 * bounds.size.height
        minusButton.layer.cornerRadius = 0.2 * bounds.size.height
    }
    
    private func didPressedStepper(value: Double) {
        updateValue(value * viewData.stepValue)
    }
    
    private func updateValue(_ newValue: Double) {
        guard (viewData.minimum...viewData.maximum) ~= (value + newValue) else {
            return
        }
        value += newValue
        var productA = productsArray.products[indexPath?.item ?? 0]
        productsArray.products.map { product in
            if product.product.name == productA.product.name {
                product.count = Int(value)
            }
        }
        counterLabel.text = String(value.formatted())
        sendActions(for: .valueChanged)
        flagZero = value == 0 ? true : false
        if flagZero {
            zeroProduct(indexPath: indexPath)
        }
    }
    
    private func stepperButton(color: UIColor, text: String, value: Int) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitle(text, for: .normal)
        button.tag = value
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(color.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = color
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1
        return button
    }
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        didPressedStepper(value: Double(sender.tag))
    }
    
    @objc
    private func zeroProduct(indexPath: IndexPath?) {
        delegate?.zeroProduct(indexPath: indexPath)
    }
    
    
}
