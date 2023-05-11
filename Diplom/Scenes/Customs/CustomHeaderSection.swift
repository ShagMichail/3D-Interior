//
//  CustomHeaderSection.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 10.02.2023.
//

import UIKit
import SnapKit

final class CustomHeaderSection: UIView {
    
    lazy var title: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        //label.font = UIFont(name: "ABosaNova", size: 18)
        label.font = .systemFont(ofSize: 26, weight: .bold)
        return label
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    required init(title: String, image: String) {
        super.init(frame: .zero)
        self.title.text = title
        self.image.image = UIImage(systemName: image)
        setupElement()
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
       // navTitle.font = UIFont(name: "ABosaNova", size: 30)
    }
    
    private func addSubviews() {
        addSubview(title)
        addSubview(image)
    }
    
    private func makeConstraints() {
        image.snp.makeConstraints {
            //$0.centerX.equalTo(self)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
            $0.top.bottom.equalTo(safeAreaLayoutGuide).inset(5)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }

        title.snp.makeConstraints {
            //$0.centerX.equalTo(self)
            $0.leading.equalTo(image.snp.trailing).inset(-20)
            $0.top.bottom.equalTo(safeAreaLayoutGuide).inset(5)
        }
    }
}
