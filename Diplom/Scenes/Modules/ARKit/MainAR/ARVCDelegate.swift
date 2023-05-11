//
//  ARVCDelegate.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 21.09.2022.
//

import ARKit

extension ARVC: ARSCNViewDelegate, ARSessionDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let isAnyObjectInView = virtualObjectLoader.loadedObjects.contains { object in
            return sceneView.isNode(object, insideFrustumOf: sceneView.pointOfView!)
        }
        
        DispatchQueue.main.async {
            self.updateFocusSquare(isObjectVisible: isAnyObjectInView)
            
            // Если открыто меню выбора объекта, обновите доступность элементов
            if self.viewIfLoaded?.window != nil {
                self.updateObjectAvailability()
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        DispatchQueue.main.async {

            if self.virtualObjectLoader.loadedObjects.isEmpty {

            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        updateQueue.async {
            if let objectAtAnchor = self.virtualObjectLoader.loadedObjects.first(where: { $0.anchor == anchor }) {
                objectAtAnchor.simdPosition = anchor.transform.translation
                objectAtAnchor.anchor = anchor
            }
        }
    }
    
    /// - Tag: ShowVirtualContent
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
            showVirtualContent()
    }

    func showVirtualContent() {
        virtualObjectLoader.loadedObjects.forEach { $0.isHidden = false }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {

        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Скройте содержимое перед переходом в фоновый режим.
        hideVirtualContent()
    }
    
    /// - Tag: HideVirtualContent
    func hideVirtualContent() {
        virtualObjectLoader.loadedObjects.forEach { $0.isHidden = true }
    }

    /*
         Позвольте сеансу попытаться возобновиться после прерывания.
         Этот процесс может не увенчаться успехом, поэтому приложение должно быть подготовлено
         чтобы сбросить сеанс, если статус перемещения сохраняется
         в течение длительного времени - см. раздел "эскалация обратной связи" в разделе "Statusviewcontroller".
         */
    /// - Tag: Relocalization
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
}
