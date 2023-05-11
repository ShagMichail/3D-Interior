//
//  RoomManager.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 14.02.2023.
//

import UIKit
import Firebase

protocol RoomManagerProtocol {
    var output: RoomManagerOutput? { get set }
    func observeRooms()
}

protocol RoomManagerOutput: AnyObject {
    func didReceive(_ rooms: [Room])
    func didFail(with error: Error)
}

enum NetworkErrorRoom: Error {
    case unexpected
}

class RoomManager: RoomManagerProtocol {
    
    var output: RoomManagerOutput?
    static let shared: RoomManagerProtocol = RoomManager()
    private let database = Firestore.firestore()
    private let roomConverter = RoomConverter()
    
    private init(){}
    
    func observeRooms() {
        database.collection("Room").addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                self?.output?.didFail(with: error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                self?.output?.didFail(with: NetworkErrorRoom.unexpected)
                return
            }
            
            let room = documents.compactMap { self?.roomConverter.room(from: $0) }
            self?.output?.didReceive(room)
        }
    }
}

private final class RoomConverter {
    enum Key: String {
        case id
        case name
    }
    
    func room(from document: DocumentSnapshot) -> Room? {
        guard let dict = document.data(),
              let id = dict[Key.id.rawValue] as? String,
              let name = dict[Key.name.rawValue] as? String else {
                  return nil
              }

        return Room(id: id,
                    name: name)
    }
}

