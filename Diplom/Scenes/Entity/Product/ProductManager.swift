//
//  ProductManager.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 14.02.2023.
//

import UIKit
import Firebase

protocol ProductManagerProtocol {
    var output: ProductManagerOutput? { get set }
    func observeProducts()
}

protocol ProductManagerOutput: AnyObject {
    func didReceive(_ products: [Product])
    func didFail(with error: Error)
}

enum NetworkErrorProduct: Error {
    case unexpected
}

class ProductManager: ProductManagerProtocol {
    
    var output: ProductManagerOutput?
    static let shared: ProductManagerProtocol = ProductManager()
    private let database = Firestore.firestore()
    private let productConverter = ProductConverter()
    
    private init(){}
    
    func observeProducts() {
        database.collection("Product").addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                self?.output?.didFail(with: error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                self?.output?.didFail(with: NetworkErrorProduct.unexpected)
                return
            }
            
            let product = documents.compactMap { self?.productConverter.product(from: $0) }
            self?.output?.didReceive(product)
        }
    }
}

private final class ProductConverter {
    enum Key: String {
        case id
        case name
        case cost
        case countSold
        case size
        case idStyle
        case idCollection
        case idRoom
        case description
        case code
        case nameModel
    }
    
    func product(from document: DocumentSnapshot) -> Product? {
        guard let dict = document.data(),
              let id = dict[Key.id.rawValue] as? String,
              let name = dict[Key.name.rawValue] as? String,
              let cost = dict[Key.cost.rawValue] as? String,
              let countSold = dict[Key.countSold.rawValue] as? String,
              let size = dict[Key.size.rawValue] as? String,
              let idStyle = dict[Key.idStyle.rawValue] as? String,
              let idCollection = dict[Key.idCollection.rawValue] as? String,
              let idRoom = dict[Key.idRoom.rawValue] as? String,
              let description = dict[Key.description.rawValue] as? String,
              let code = dict[Key.code.rawValue] as? String,
              let nameModel = dict[Key.nameModel.rawValue] as? String
        else {
            return nil
        }

        return Product(
            id: id,
            cost: cost,
            countSold: countSold,
            name: name,
            size: size,
            idStyle: idStyle,
            idCollection: idCollection,
            idRoom: idRoom,
            description: description,
            code: code,
            nameModel: nameModel
        )
    }
}

