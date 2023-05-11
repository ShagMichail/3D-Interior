//
//  HomeVCModel.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 16.02.2023.
//

import UIKit

protocol HomeVCModelDescription: AnyObject {
    var output: HomeVCInput? { get set }
    func loadNewCollections()
    func loadStyls()
    func loadProducts()
//    func update(product: Room)
}

final class HomeVCModel: HomeVCModelDescription {
    
    private var newCollectionsManager: NewCollectionManagerProtocol = NewCollectionManager.shared
    private var productManager: ProductManagerProtocol = ProductManager.shared
    private var styleManager: StyleManagerProtocol = StyleManager.shared
    
    weak var output: HomeVCInput?
    
    func loadNewCollections() {
        newCollectionsManager.observeNewCollections()
        newCollectionsManager.output = self
    }
    
    func loadStyls() {
        styleManager.observeStyls()
        styleManager.output = self
    }
    
    func loadProducts() {
        productManager.observeProducts()
        productManager.output = self
    }
    
//    func update(product: Product) {
//        productManager.update(product: product)
//    }
}


extension HomeVCModel: NewCollectionManagerOutput {
    func didReceive(_ newCollection: [NewCollection]) {
        output?.didReceive(newCollection)
    }

    func didFail(with error: Error) {
        // show error
    }
}

extension HomeVCModel: ProductManagerOutput {
    func didReceive(_ product: [Product]) {
        output?.didReceive(product)
    }
}

extension HomeVCModel: StyleManagerOutput {
    func didReceive(_ style: [Style]) {
        output?.didReceive(style)
    }
}
