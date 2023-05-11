//
//  BasketViewCell.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 11.02.2023.
//

import UIKit
import SnapKit

final class BasketViewCell: UITableViewCell {
    
    weak var delegate: StepperDelegate?
    
    var indexPath: IndexPath?
    
    static let identifier = "BasketViewCell"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var codeLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    lazy var stepper = RoundStepper(viewData: RoundStepper.ViewData(color: .systemBlue, minimum: 0, maximum: 30, stepValue: 1))
    
    
    //MARK: -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        contentView.backgroundColor = .clear
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    func configure(score: Int, indexPath: IndexPath, data: ProductBasket) {
        nameLabel.text = data.product.name
        codeLabel.text = data.product.code
        scoreLabel.text = "\(score)."
        stepper.counterLabel.text = String(data.count)
        stepper.value = Double(data.count)
        stepper.delegate = delegate
        stepper.indexPath = indexPath
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(scoreLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(codeLabel)
        containerView.addSubview(stepper)
    }
    
    private func setupLayout() {
        
        containerView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).inset(20)
            $0.trailing.equalTo(nameLabel.snp.leading).inset(-10)
            $0.top.equalTo(containerView).inset(5)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(scoreLabel.snp.trailing).inset(-10)
            $0.top.equalTo(containerView.snp.top).inset(5)
        }
        
        codeLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).inset(45)
            $0.top.equalTo(nameLabel.snp.bottom).inset(-5)
            $0.bottom.equalTo(containerView.snp.bottom).inset(10)
        }
        
        stepper.snp.makeConstraints {
            $0.trailing.equalTo(containerView.snp.trailing).inset(10)
            $0.top.bottom.equalTo(containerView).inset(5)
        }
    }
}

