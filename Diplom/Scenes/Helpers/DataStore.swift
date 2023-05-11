//
//  DataStore.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 20.02.2023.
//

import UIKit

class ProductBasket {
    var product: Product
    var count: Int
    
    init(product: Product, count: Int) {
        self.product = product
        self.count = count
    }
}

protocol StoresProduct: AnyObject {
//    var product: (product: Product, count: Int) { get set }
    var products: [ProductBasket] { get set }
}

final class ProductDataStore: StoresProduct {
    
//    var item: (Product, Int) = (.init(id: "", cost: "", countSold: "", name: "", size: "", idStyle: "", idCollection: "", idRoom: "", description: "", code: ""), 0)
//    var product: (product: Product, count: Int) = (.init(id: "", cost: "", countSold: "", name: "", size: "", idStyle: "", idCollection: "", idRoom: "", description: "", code: ""), 0)
    var products: [ProductBasket] = []
    
    static let shared = ProductDataStore()
    
}
