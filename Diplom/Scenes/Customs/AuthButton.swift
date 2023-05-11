//
//  File.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit

final class AuthButton: UIButton {
    
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 25
        backgroundColor = UIColor.yellow
        setTitleColor(UIColor(white: 1, alpha: 1.0), for: .normal)
        setHeight(height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
