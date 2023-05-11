//
//  FavoriteProductCell.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 10.02.2023.
//

import UIKit
import SnapKit

final class FavoriteProductCell: UITableViewCell {
    
    
    //MARK: -
    
    //    private struct Constants {
    //        static let labelPosition: CGFloat = 20
    //        static let imageFromLeftRight: CGFloat = 12
    //        static let imageFromTopBottom: CGFloat = 5
    //    }
    
    static let identifier = "FavoriteProductCell"
    //private let gradient = CAGradientLayer()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var soldDefaultLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Уже проданно:"
        return label
    }()
    
    lazy var soldLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var costDefaultLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Стоимость:"
        return label
    }()
    
    lazy var costLabel: UILabel = {
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
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 5, height: 10)
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    //MARK: -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .default
        contentView.backgroundColor = .clear
        
        setupViews()
        //setupGradient()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    func configure(with data: Product) {
        nameLabel.text = data.name
        soldLabel.text = data.countSold
        costLabel.text = data.cost
        mainImageView.sizeToFit()
    }
    
    func getImageView() -> UIImageView {
        return mainImageView
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(mainImageView)
        containerView.addSubview(nameView)
        nameView.addSubview(nameLabel)
        containerView.addSubview(soldDefaultLabel)
        containerView.addSubview(soldLabel)
        containerView.addSubview(costDefaultLabel)
        containerView.addSubview(costLabel)
    }
    
    private func setupLayout() {
        
        containerView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        nameView.snp.makeConstraints {
            $0.leading.equalTo(mainImageView.snp.trailing).inset(-10)
            $0.trailing.equalTo(nameLabel.snp.trailing).inset(-5)
            $0.top.equalTo(containerView.snp.top).inset(10)
            $0.bottom.equalTo(nameLabel.snp.bottom).inset(-3)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(nameView.snp.leading).inset(5)
            $0.trailing.equalTo(nameView.snp.trailing).inset(-5)
            $0.top.equalTo(nameView.snp.top).inset(3)
            $0.bottom.equalTo(nameView.snp.bottom).inset(-3)
        }
        
        soldDefaultLabel.snp.makeConstraints {
            $0.leading.equalTo(mainImageView.snp.trailing).inset(-10)
            $0.top.equalTo(nameView.snp.bottom).inset(-3)
        }
        
        soldLabel.snp.makeConstraints {
            $0.leading.equalTo(soldDefaultLabel.snp.trailing).inset(-10)
            $0.top.equalTo(nameView.snp.bottom).inset(-3)
        }
        
        costDefaultLabel.snp.makeConstraints {
            $0.leading.equalTo(mainImageView.snp.trailing).inset(-10)
            $0.top.equalTo(soldLabel.snp.bottom).inset(-5)
        }
        
        costLabel.snp.makeConstraints {
            $0.leading.equalTo(costDefaultLabel.snp.trailing).inset(-10)
            $0.top.equalTo(soldLabel.snp.bottom).inset(-5)
        }
        
        mainImageView.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            $0.trailing.equalTo(costDefaultLabel.snp.leading).inset(-10)
            $0.leading.equalTo(containerView.snp.leading).inset(10)
            $0.width.equalTo(150)
        }
    }
}

