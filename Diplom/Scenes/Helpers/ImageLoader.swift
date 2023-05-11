//
//  ProductImageLoader.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 21.02.2023.
//

import UIKit
import FirebaseStorage

final class ImageLoader {
    let storage = Storage.storage().reference()
    static let shared = ImageLoader()
    
    func getReference(with name: String, completion: @escaping (StorageReference) -> Void) {
        let reference = storage.child(name)
        completion(reference)
    }
}
