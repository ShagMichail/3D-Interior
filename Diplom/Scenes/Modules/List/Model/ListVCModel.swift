//
//  ListVCModel.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 14.02.2023.
//

import UIKit

protocol ListVCModelDescription: AnyObject {
    var output: ListVCInput? { get set }
    func loadRooms()
//    func update(product: Room)
}

final class ListVCModel: ListVCModelDescription {
    
    private var roomManager: RoomManagerProtocol = RoomManager.shared
    
    weak var output: ListVCInput?
    
    func loadRooms() {
        roomManager.observeRooms()
        roomManager.output = self
    }
    
//    func update(product: Product) {
//        productManager.update(product: product)
//    }
}


extension ListVCModel: RoomManagerOutput {
    func didReceive(_ room: [Room]) {
        output?.didReceive(room)
    }

    func didFail(with error: Error) {
        // show error
    }
}
