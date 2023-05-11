//
//  EmptyView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 20.02.2023.
//

import UIKit
import SnapKit

final class EmptyView: UIView {
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваша корзина пока пуста"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "trash")
        image.tintColor = UIColor.black
        return image
    }()
    
    required init() {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews()
        makeConstraints()
        
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(emptyLabel)
        addSubview(image)
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        image.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height/3.5)
            $0.width.equalTo(UIScreen.main.bounds.width/2)
        }
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).inset(-20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
}

