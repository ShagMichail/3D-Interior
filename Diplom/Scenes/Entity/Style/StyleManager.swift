//
//  StyleManager.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 16.02.2023.
//

import UIKit
import Firebase

protocol StyleManagerProtocol {
    var output: StyleManagerOutput? { get set }
    func observeStyls()
}

protocol StyleManagerOutput: AnyObject {
    func didReceive(_ style: [Style])
    func didFail(with error: Error)
}

enum NetworkErrorStyle: Error {
    case unexpected
}

class StyleManager: StyleManagerProtocol {
    
    var output: StyleManagerOutput?
    static let shared: StyleManagerProtocol = StyleManager()
    private let database = Firestore.firestore()
    private let styleConverter = StyleConverter()
    
    private init(){}
    
    func observeStyls() {
        database.collection("Style").addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                self?.output?.didFail(with: error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                self?.output?.didFail(with: NetworkErrorStyle.unexpected)
                return
            }
            
            let style = documents.compactMap { self?.styleConverter.style(from: $0) }
            self?.output?.didReceive(style)
        }
    }
}

private final class StyleConverter {
    enum Key: String {
        case id
        case name
        case description
    }
    
    func style(from document: DocumentSnapshot) -> Style? {
        guard let dict = document.data(),
              let id = dict[Key.id.rawValue] as? String,
              let name = dict[Key.name.rawValue] as? String,
              let description = dict[Key.description.rawValue] as? String else {
            return nil
        }

        return Style(
            id: id,
            name: name,
            description: description
        )
    }
}



