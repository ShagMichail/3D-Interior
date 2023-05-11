//
//  NewCollectionManager.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 16.02.2023.
//

import UIKit
import Firebase

protocol NewCollectionManagerProtocol {
    var output: NewCollectionManagerOutput? { get set }
    func observeNewCollections()
}

protocol NewCollectionManagerOutput: AnyObject {
    func didReceive(_ newCollection: [NewCollection])
    func didFail(with error: Error)
}

enum NetworkErrorNewCollection: Error {
    case unexpected
}

class NewCollectionManager: NewCollectionManagerProtocol {
    
    var output: NewCollectionManagerOutput?
    static let shared: NewCollectionManagerProtocol = NewCollectionManager()
    private let database = Firestore.firestore()
    private let newCollectionConverter = NewCollectionConverter()
    
    private init(){}
    
    func observeNewCollections() {
        database.collection("NewCollection").addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                self?.output?.didFail(with: error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                self?.output?.didFail(with: NetworkErrorNewCollection.unexpected)
                return
            }
            
            let newCollection = documents.compactMap { self?.newCollectionConverter.newCollection(from: $0) }
            self?.output?.didReceive(newCollection)
        }
    }
}

private final class NewCollectionConverter {
    enum Key: String {
        case id
        case name
    }
    
    func newCollection(from document: DocumentSnapshot) -> NewCollection? {
        guard let dict = document.data(),
              let id = dict[Key.id.rawValue] as? String,
              let name = dict[Key.name.rawValue] as? String else {
            return nil
        }

        return NewCollection(
            id: id,
            name: name
        )
    }
}


