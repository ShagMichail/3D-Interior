//
//  VirtualObjectLoader.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 20.09.2022.
//

import Foundation
import ARKit

/**
 Загружает несколько виртуальных объектов в фоновую очередь, чтобы иметь возможность
быстро отображать объекты, как только они понадобятся.
*/
class VirtualObjectLoader {
    private(set) var loadedObjects = [VirtualObject]()
    
    private(set) var isLoading = false
    
    // MARK: - Loading object

    /**
         Загружает `Виртуальный объект` в фоновую очередь. вызывается `загруженный обработчик`
         в фоновой очереди после загрузки "объекта".
        */
    func loadVirtualObject(_ object: VirtualObject, loadedHandler: @escaping (VirtualObject) -> Void) {
        isLoading = true
        loadedObjects.append(object)
        
        // Загрузите содержимое в ссылочный узел.
        DispatchQueue.global(qos: .userInitiated).async {
            object.load()
            self.isLoading = false
            loadedHandler(object)
        }
    }
    
    // MARK: - Removing Objects
    
    func removeAllVirtualObjects() {
        // Переверните индексы, чтобы мы не топтали индексы при удалении объектов.
        for index in loadedObjects.indices.reversed() {
            removeVirtualObject(at: index)
        }
    }

    /// - Tag: RemoveVirtualObject
    func removeVirtualObject(at index: Int) {
        guard loadedObjects.indices.contains(index) else { return }
        
        // Остановите наложение отслеживаемого луча на объект.
        loadedObjects[index].stopTrackedRaycast()
        
        // Удалите визуальный узел из графика сцены.
        loadedObjects[index].removeFromParentNode()
        // Окупить ресурсы, выделенные объектом.
        loadedObjects[index].unload()
        loadedObjects.remove(at: index)
    }
}
