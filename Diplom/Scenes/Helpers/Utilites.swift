//
//  Utilites.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 20.09.2022.
//

import Foundation
import ARKit

// MARK: - float4x4 extensions

extension float4x4 {
    /**
    Обрабатывает матрицу как матрицу преобразования (основное соглашение по правому столбцу)
    и учитывает переводческий компонент преобразования.
    */
    var translation: SIMD3<Float> {
        get {
            let translation = columns.3
            return [translation.x, translation.y, translation.z]
        }
        set(newValue) {
            columns.3 = [newValue.x, newValue.y, newValue.z, columns.3.w]
        }
    }
    
    /**
         Учитывает ориентационный компонент преобразования.
        */
    var orientation: simd_quatf {
        return simd_quaternion(self)
    }
    
    /**
         Создает матрицу преобразования с одинаковым масштабным коэффициентом во всех направлениях.
         */
    init(uniformScale scale: Float) {
        self = matrix_identity_float4x4
        columns.0.x = scale
        columns.1.y = scale
        columns.2.z = scale
    }
}

// MARK: - CGPoint extensions

extension CGPoint {
    /// Извлекает точку экранного пространства из вектора, возвращаемого SCNView.projectPoint(_:).
    init(_ vector: SCNVector3) {
        self.init(x: CGFloat(vector.x), y: CGFloat(vector.y))
    }

    /// Возвращает длину точки, если рассматривать ее как вектор. (Используется с распознавателями жестов.)
    var length: CGFloat {
        return sqrt(x * x + y * y)
    }
}

extension UILabel {

    func startBlink() {
        UIView.animate(withDuration: 0.8,
              delay:0.0,
              options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
              animations: { self.alpha = 0 },
              completion: nil)
    }

    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}
