//
//  VirtualOdject.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 20.09.2022.
//

import Foundation
import SceneKit
import ARKit

class VirtualObject: SCNReferenceNode {
    
    /// Название модели, полученное из `ссылочного URL`.
    var modelName: String {
        return referenceURL.lastPathComponent.replacingOccurrences(of: ".scn", with: "")
    }
    
    /// Выравнивания, разрешенные для виртуального объекта.
    var allowedAlignment: ARRaycastQuery.TargetAlignment {
        if modelName == "sticky note" {
            return .any
        } else if modelName == "painting" {
            return .vertical
        } else {
            return .horizontal
        }
    }
    
    /// Поворачивает первый дочерний узел виртуального объекта.
    /// - Примечание: Для правильного вращения на горизонтальных и вертикальных поверхностях поверните вокруг
    /// локально, а не по всему миру.
    var objectRotation: Float {
        get {
            return childNodes.first!.eulerAngles.y
        }
        set (newValue) {
            childNodes.first!.eulerAngles.y = newValue
        }
    }
    
    /// // Соответствующий объект Anarcho.
    var anchor: ARAnchor?

    /// Запрос raycast, используемый при размещении этого объекта.
    var raycastQuery: ARRaycastQuery?
    
    /// Связанный отслеживаемый raycast, используемый для размещения этого объекта.
    var raycast: ARTrackedRaycast?
    
    /// Самый последний результат raycast, используемый для определения начального местоположения
    /// объекта после размещения.
    var mostRecentInitialPlacementResult: ARRaycastResult?
    
    /// Флаг, указывающий, что связанный якорь должен быть обновлен
    /// в конце жеста панорамирования или при изменении положения объекта.
    var shouldUpdateAnchor = false
    
    ///Перестает отслеживать положение и ориентацию объекта.
    /// - Tag: StopTrackedRaycasts
    func stopTrackedRaycast() {
        raycast?.stopTracking()
        raycast = nil
    }
}

extension VirtualObject {
    // MARK: Static Properties and Methods
    ///Загружает все объекты модели в `Models.sceneassets`.
    static let availableObjects: [VirtualObject] = {
        let modelsURL = Bundle.main.url(forResource: "art.scnassets", withExtension: nil)!

        let fileEnumerator = FileManager().enumerator(at: modelsURL, includingPropertiesForKeys: [])!

        return fileEnumerator.compactMap { element in
            let url = element as! URL

            guard url.pathExtension == "scn" && !url.path.contains("lighting") else { return nil }

            return VirtualObject(url: url)
        }
    }()
    
    ///  Возвращает `Виртуальный объект`, если таковой существует в качестве предка предоставленного узла.
    static func existingObjectContainingNode(_ node: SCNNode) -> VirtualObject? {
        if let virtualObjectRoot = node as? VirtualObject {
            return virtualObjectRoot
        }
        
        guard let parent = node.parent else { return nil }
        
        //Выполните рекурсию вверх, чтобы проверить, является ли родительский элемент "виртуальным объектом".
        return existingObjectContainingNode(parent)
    }
}
