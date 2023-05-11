//
//  CustomHeader.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 26.01.2023.
//

import Foundation
import UIKit

final class CustomHeader: UIView {
    
    lazy var navTitle: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "ABosaNova", size: 30)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrowshape.turn.up.left"), for: .normal)
        button.imageView?.isUserInteractionEnabled = false
        //button.sizeThatFits(CGSize(width: 100, height: 100))
        return button
    }()
    
    lazy var basketButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "cart"), for: .normal)
        button.imageView?.isUserInteractionEnabled = false
        //button.sizeThatFits(CGSize(width: 100, height: 100))
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElement()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
       // navTitle.font = UIFont(name: "ABosaNova", size: 30)
    }
    
    private func addSubviews() {
        addSubview(navTitle)
        addSubview(backButton)
        addSubview(basketButton)
    }
    
    private func makeConstraints() {
        backButton.snp.makeConstraints {
            //$0.centerX.equalTo(self)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }

        navTitle.snp.makeConstraints {
            //$0.centerX.equalTo(self)
            $0.leading.equalTo(backButton.snp.trailing).inset(-20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20).priority(.low)
        }
        
        basketButton.snp.makeConstraints {
            //$0.centerX.equalTo(self)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }

    }
}
