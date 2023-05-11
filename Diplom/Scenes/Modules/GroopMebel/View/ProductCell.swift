//
//  ProductCell.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 13.09.2022.
//

import UIKit
import SnapKit

final class ProductCell: UICollectionViewCell {
    
    
    //MARK: -
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 5, height: 10)
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    lazy var nameProductLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
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
    
    lazy var productImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.sizeToFit()
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    
    //MARK: -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddition()
        setupElements()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    func setupElements() {
        
    }
    
    func configure(with data: Product){
        nameProductLabel.text = data.name
    }
    
    func getImageView() -> UIImageView {
        return productImage
    }
    
    private func setupAddition() {
        contentView.addSubview(containerView)
        containerView.addSubview(productImage)
        containerView.addSubview(nameView)
        nameView.addSubview(nameProductLabel)
    }
}


//MARK: -

extension ProductCell {
    
    func setupLayout() {
        
        containerView.snp.makeConstraints {            $0.top.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        productImage.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).inset(0)
            $0.bottom.equalTo(containerView.snp.bottom).inset(40)
            $0.leading.equalTo(containerView.snp.leading).inset(0)
            $0.trailing.equalTo(containerView.snp.trailing).inset(0)
        }
        
        nameView.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).inset(5)
            $0.trailing.equalTo(nameProductLabel.snp.trailing).inset(-5)
            $0.top.equalTo(productImage.snp.bottom).inset(-5)
            $0.bottom.equalTo(nameProductLabel.snp.bottom).inset(-3)
        }
        
        nameProductLabel.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.top).inset(3)
            $0.leading.equalTo(nameView.snp.leading).inset(5)
            $0.trailing.equalTo(nameView.snp.trailing).inset(-5)
            $0.bottom.equalTo(nameView.snp.bottom).inset(-3)
        }
        
    }
}


//MARK: -

extension ProductCell {
    
    static var nib  : UINib{
        return UINib(nibName: identifire, bundle: nil)
    }
    
    static var identifire : String{
        return String(describing: self)
    }
}
