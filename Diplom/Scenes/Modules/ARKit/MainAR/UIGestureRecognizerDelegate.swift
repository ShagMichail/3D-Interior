//
//  UIGestureRecognizerDelegate.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 21.09.2022.
//

import UIKit
import ARKit

extension ARVC: UIGestureRecognizerDelegate {

    enum SegueIdentifier: String {
        case showObjects
    }

    // MARK: - Interface Actions

    /// Определяет, следует ли использовать жест касания для представления "Контроллера представления выбора виртуального объекта".
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return virtualObjectLoader.loadedObjects.isEmpty
    }

    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /// Отображает `Контроллер представления выбора виртуального объекта" с помощью "Кнопки добавления объекта" или в ответ на жест касания в "просмотре сцены".
    @objc
    private func showVirtualObjectSelectionViewController() {
        // Убедитесь, что добавление объектов является доступным действием, и мы не загружаем другой объект (чтобы избежать одновременных модификаций сцены).
        guard !closeButton.isHidden && !virtualObjectLoader.isLoading else { return }

        //statusViewController.отменить запланированное сообщение (для: .Размещения контента)
        performSegue(withIdentifier: SegueIdentifier.showObjects.rawValue, sender: closeButton)
    }
}
