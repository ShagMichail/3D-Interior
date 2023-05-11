//
//  ARCoachingOverlayViewDelegate.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 21.09.2022.
//

import UIKit
import ARKit

extension ARVC: ARCoachingOverlayViewDelegate {
    
    /// - Tag: HideUI
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        closeButton.isHidden = true
//        restartButton.isHidden = true
//        addButton.isHidden = true
//        hideSquareButton.isHidden = true
//        if isAdditingObject {
//            hideSquareButton.isHidden = true
//        } else {
//            addButton.isHidden = true
//        }
        
    }
    
    /// - Tag: PresentUI
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        closeButton.isHidden = false
//        restartButton.isHidden = false
//        if isAdditingObject {
//            hideSquareButton.isHidden = false
//        } else {
//            addButton.isHidden = false
//        }
        //restartButton.isHidden = false
    }
    
    func setupCoachingOverlay() {
        // Настройка представления коучинга
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        
        setActivatesAutomatically()
        
        // Большинству виртуальных объектов в этом примере требуется горизонтальная поверхность,
        // поэтому научите пользователя находить горизонтальную плоскость.
        setGoal()
    }
    /// - Tag: CoachingActivatesAutomatically
    func setActivatesAutomatically() {
        coachingOverlay.activatesAutomatically = true
    }

    /// - Tag: CoachingGoal
    func setGoal() {
        coachingOverlay.goal = .horizontalPlane
    }
}
