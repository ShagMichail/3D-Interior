//
//  StyleImageLoader.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 21.02.2023.
//

import UIKit
import FirebaseStorage

final class StyleImageLoader {
    let storage = Storage.storage().reference()
    static let shared = StyleImageLoader()
    
    func getReference(with name: String, completion: @escaping (StorageReference) -> Void) {
        let reference = storage.child(name)
        completion(reference)
    }
}
