//
//  File.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit

final class CustomTextField: UITextField {
    
    init(placeholder: String){
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        layer.cornerRadius = 10
        
        borderStyle = .none
        textColor = .black
        keyboardAppearance = .dark
        backgroundColor = .systemGray6
        setHeight(height: 50)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.systemGray2])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
