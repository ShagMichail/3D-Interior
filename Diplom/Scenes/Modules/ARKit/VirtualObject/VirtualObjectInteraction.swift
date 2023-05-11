//
//  VirtualObjectInteraction.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 20.09.2022.
//

import UIKit
import ARKit

/// - Tag: VirtualObjectInteraction
class VirtualObjectInteraction: NSObject, UIGestureRecognizerDelegate {
    
    /// Настройка разработчика для перевода предполагает, что обнаруженная плоскость простирается бесконечно.
    let translateAssumingInfinitePlane = true
    
    /// Вид сцены для проверки при перемещении виртуального содержимого.
    let sceneView: VirtualObjectARView
    
    /// Ссылка на контроллер представления.
    let viewController: ARVC
    
    /**
         Объект, с которым в последний раз взаимодействовали.
         `Выбранный объект` можно переместить в любое время с помощью жеста касания.
         */
    var selectedObject: VirtualObject?
    
    /// Объект, который отслеживается для использования жестами панорамирования и поворота.
    var trackedObject: VirtualObject? {
        didSet {
            guard trackedObject != nil else { return }
            selectedObject = trackedObject
        }
    }
    
    /// Отслеживаемое положение экрана, используемое для обновления положения `отслеживаемого объекта`.
    private var currentTrackingPosition: CGPoint?
    
    init(sceneView: VirtualObjectARView, viewController: ARVC) {
        self.sceneView = sceneView
        self.viewController = viewController
        super.init()
        
        createPanGestureRecognizer(sceneView)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotationGesture.delegate = self
        sceneView.addGestureRecognizer(rotationGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    // - Tag: CreatePanGesture
    func createPanGestureRecognizer(_ sceneView: VirtualObjectARView) {
        let panGesture = ThresholdPanGesture(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        sceneView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Gesture Actions
    
    @objc
    func didPan(_ gesture: ThresholdPanGesture) {
        switch gesture.state {
        case .began:
            // Проверьте наличие объекта в месте касания.
            if let object = objectInteracting(with: gesture, in: sceneView) {
                trackedObject = object
            }
            
        case .changed where gesture.isThresholdExceeded:
            guard let object = trackedObject else { return }
            // Переместите объект, если был достигнут порог перемещения.
            translate(object, basedOn: updatedTrackingPosition(for: object, from: gesture))

            gesture.setTranslation(.zero, in: sceneView)
            
        case .changed:
            // Игнорируйте жест панорамирования до тех пор, пока не будет превышен порог перемещения.
            break
            
        case .ended:
            // Обновите положение объекта, когда пользователь прекратит панорамирование.
            guard let object = trackedObject else { break }
            setDown(object, basedOn: updatedTrackingPosition(for: object, from: gesture))
            
            fallthrough
            
        default:
            // Сбросьте отслеживание текущего положения.
            currentTrackingPosition = nil
            trackedObject = nil
        }
    }
    
    func updatedTrackingPosition(for object: VirtualObject, from gesture: UIPanGestureRecognizer) -> CGPoint {
        let translation = gesture.translation(in: sceneView)
        
        let currentPosition = currentTrackingPosition ?? CGPoint(sceneView.projectPoint(object.position))
        let updatedPosition = CGPoint(x: currentPosition.x + translation.x, y: currentPosition.y + translation.y)
        currentTrackingPosition = updatedPosition
        return updatedPosition
    }

    /**
         Для того, чтобы смотреть на объект сверху вниз (99% всех случаев использования), вы вычитаете угол.
         Чтобы вращение также работало корректно при взгляде снизу объекта, нужно было бы
    перевернуть знак угла в зависимости от того, находится ли объект выше или ниже камеры.
         - - Тег: сделал поворот */
    @objc
    func didRotate(_ gesture: UIRotationGestureRecognizer) {
        guard gesture.state == .changed else { return }
        
        trackedObject?.objectRotation -= Float(gesture.rotation)
        
        gesture.rotation = 0
    }
    
    /// Обрабатывает взаимодействие, когда пользователь нажимает на экран.
    @objc
    func didTap(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: sceneView)
        
        if let tappedObject = sceneView.virtualObject(at: touchLocation) {
            
            // Если объект существует в месте касания, выберите его.
            selectedObject = tappedObject
        } else if let object = selectedObject {
            
            // В противном случае переместите выбранный объект в его новое положение в месте касания.
            setDown(object, basedOn: touchLocation)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Разрешить одновременный перевод и поворот объектов.
        return true
    }

    /** Вспомогательный метод для возврата первого объекта, который найден в местах касания предоставленного жеста.
     Выполняет тесты попадания, используя места касания, предоставляемые распознавателями жестов. Путем тестирования попадания на ограничивающую
     что касается виртуальных объектов, то эта функция повышает вероятность того, что прикосновение пользователя повлияет на объект, даже если
местоположение касания не находится в точке, где объект имеет видимое содержимое. Путем выполнения тестов с несколькими нажатиями для мультитач
     жесты, этот метод повышает вероятность того, что прикосновение пользователя повлияет на предполагаемый объект.
      - Tag: TouchTesting
    */
    private func objectInteracting(with gesture: UIGestureRecognizer, in view: ARSCNView) -> VirtualObject? {
        for index in 0..<gesture.numberOfTouches {
            let touchLocation = gesture.location(ofTouch: index, in: view)
            
            // Найдите объект непосредственно под `Местоположением касания`.
            if let object = sceneView.virtualObject(at: touchLocation) {
                return object
            }
        }
        
        // В крайнем случае ищите объект под центром штрихов.
        if let center = gesture.center(in: view) {
            return sceneView.virtualObject(at: center)
        }
        
        return nil
    }
    
    // MARK: - Update object position
    /// - Tag: DragVirtualObject
    func translate(_ object: VirtualObject, basedOn screenPos: CGPoint) {
        object.stopTrackedRaycast()
        
        // Обновите объект с помощью одноразового запроса местоположения.
        if let query = sceneView.raycastQuery(from: screenPos, allowing: .estimatedPlane, alignment: object.allowedAlignment) {
            viewController.createRaycastAndUpdate3DPosition(of: object, from: query)
        }
    }
    
    func setDown(_ object: VirtualObject, basedOn screenPos: CGPoint) {
        object.stopTrackedRaycast()
        
        // Подготовьтесь к обновлению привязки объекта к текущему местоположению.
        object.shouldUpdateAnchor = true
        
        // Попытайтесь создать новую отслеживаемую радиопередачу из текущего местоположения.
        if let query = sceneView.raycastQuery(from: screenPos, allowing: .estimatedPlane, alignment: object.allowedAlignment),
            let raycast = viewController.createTrackedRaycastAndSet3DPosition(of: object, from: query) {
            object.raycast = raycast
        } else {
            // Если отслеживаемая передача лучей не удалась, просто обновите привязку к текущему положению объекта.
            object.shouldUpdateAnchor = false
            viewController.updateQueue.async {
                self.sceneView.addOrUpdateAnchor(for: object)
            }
        }
    }
    
}

/// Расширяет "UIGestureRecognizer", чтобы обеспечить центральную точку, полученную в результате нескольких касаний.
extension UIGestureRecognizer {
    func center(in view: UIView) -> CGPoint? {
        guard numberOfTouches > 0 else { return nil }
        
        let first = CGRect(origin: location(ofTouch: 0, in: view), size: .zero)

        let touchBounds = (1..<numberOfTouches).reduce(first) { touchBounds, index in
            return touchBounds.union(CGRect(origin: location(ofTouch: index, in: view), size: .zero))
        }

        return CGPoint(x: touchBounds.midX, y: touchBounds.midY)
    }
}
