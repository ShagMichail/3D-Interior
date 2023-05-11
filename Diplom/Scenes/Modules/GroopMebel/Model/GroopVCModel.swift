//
//  GroopVCModel.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 14.02.2023.
//

import UIKit

protocol GroopVCModelDescription: AnyObject {
    var output: GroopVCInput? { get set }
    func loadProducts()
//    func update(product: Room)
}

final class GroopVCModel: GroopVCModelDescription {
    
    private var productManager: ProductManagerProtocol = ProductManager.shared
    
    weak var output: GroopVCInput?
    
    func loadProducts() {
        productManager.observeProducts()
        productManager.output = self
    }
    
//    func update(product: Product) {
//        productManager.update(product: product)
//    }
}


extension GroopVCModel: ProductManagerOutput {
    func didReceive(_ product: [Product]) {
        output?.didReceive(product)
    }

    func didFail(with error: Error) {
        // show error
    }
}

