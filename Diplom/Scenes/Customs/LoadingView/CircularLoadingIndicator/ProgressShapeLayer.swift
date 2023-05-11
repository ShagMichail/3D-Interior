//
//  ProgressShapeLayer.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 16.02.2023.
//

import UIKit

class ProgressShapeLayer: CAShapeLayer {
    
    public init(strokeColor: UIColor, lineWidth: CGFloat) {
        super.init()
        
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth
        self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
