//
//  MainAR.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 20.09.2022.
//

import UIKit
import ARKit
import SceneKit
import SnapKit

//https://www.youtube.com/watch?v=wioMSE3PF98

final class ARVC: UIViewController {
    
    private let message = UILabel()
    private let configuration = ARWorldTrackingConfiguration()
    
    private var lastObjectAvailabilityUpdateTimestamp: TimeInterval?
    private var isHideSquare = Bool()
    
    let coachingOverlay = ARCoachingOverlayView()
    let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")
    /// Координирует загрузку и выгрузку опорных узлов для виртуальных объектов.
    let virtualObjectLoader = VirtualObjectLoader()
    let loadingIndicator: ProgressView = {
            let progress = ProgressView(colors: [.red, .systemGreen, .systemBlue], lineWidth: 5)
            progress.translatesAutoresizingMaskIntoConstraints = false
            return progress
        }()
    
    var nameObject: String?
    var isAdditingObject = Bool()
    var focusSquare = FocusSquare()
    var sceneView = VirtualObjectARView()
    /// Отмечает, доступен ли опыт AR для перезапуска.
    var isRestartAvailable = true
    var object = VirtualObject()
    /// Коллекция виртуальных объектов для выбора.
    var virtualObjects = [VirtualObject]()
    /// Удобный аксессуар для сеанса, принадлежащего Arcview.
    var session: ARSession {
        return sceneView.session
    }
    
    /// Тип, который управляет жестовыми манипуляциями с виртуальным контентом в сцене.
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView, viewController: self)
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.left.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor.systemBlue
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor.systemBlue
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    lazy var restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        button.setImage(UIImage(systemName: "repeat"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        //button.backgroundColor = UIColor.systemBlue
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapRestartExperience), for: .touchUpInside)
        return button
    }()
    
    lazy var hideSquareButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor.systemBlue
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapHideSquare), for: .touchUpInside)
        return button
    }()
    
    var spinner = UIActivityIndicatorView()
    
    required init(
        name: String?
    ) {
        self.nameObject = name
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupElement()
        setupAddition()
        setupLayout()
        setupNavBar()
        
        setupLoadingObject()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        setupCoachingOverlay()
        
        sceneView.scene.rootNode.addChildNode(focusSquare)
        
        let tapGesture = UITapGestureRecognizer()
        // Установите делегат, чтобы гарантировать, что этот жест используется только тогда, когда в сцене нет виртуальных объектов.
        tapGesture.delegate = self
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Не допускайте затемнения экрана, чтобы не прерывать работу AR.
        UIApplication.shared.isIdleTimerDisabled = true

        // Start the `ARSession`.
        resetTracking()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    private func setupLoadingObject() {
        self.virtualObjects = VirtualObject.availableObjects.filter { $0.modelName == self.nameObject }
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupElement() {
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        
        message.text = "Минуточку..."
        message.isHidden = true
        
        isHideSquare = false
        isAdditingObject = false
    
        hideSquareButton.isHidden = true
    }
    
    private func setupAddition() {
        view.addSubview(sceneView)
        view.addSubview(closeButton)
        view.addSubview(addButton)
        view.addSubview(restartButton)
//        view.addSubview(message)
        view.addSubview(loadingIndicator)
        view.addSubview(hideSquareButton)
    }
    
    private func setupLayout() {
        
//        sceneView.snp.makeConstraints {
//            $0.leading.trailing.top.bottom
//        }
        
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            restartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            restartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            restartButton.heightAnchor.constraint(equalToConstant: 52),
            restartButton.widthAnchor.constraint(equalToConstant: 52),
            
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: (UIScreen.main.bounds.width / 2) - 65),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            closeButton.heightAnchor.constraint(equalToConstant: 52),
            closeButton.widthAnchor.constraint(equalToConstant: 52),
            
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: (UIScreen.main.bounds.width / 2) + 13),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 52),
            addButton.widthAnchor.constraint(equalToConstant: 52),
            
            hideSquareButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: (UIScreen.main.bounds.width / 2) + 13),
            hideSquareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            hideSquareButton.heightAnchor.constraint(equalToConstant: 52),
            hideSquareButton.widthAnchor.constraint(equalToConstant: 52),
            
            loadingIndicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: (UIScreen.main.bounds.width / 2) - 16),
            loadingIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 32),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 32),
//
//            message.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
//            message.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -30),
//            message.heightAnchor.constraint(equalToConstant: 52),
            //message.widthAnchor.constraint(equalToConstant: 52),
            
        ])
    }
    
    /// Создает новую конфигурацию AR для запуска в `сеансе`.
    func resetTracking() {
        virtualObjectInteraction.selectedObject = nil
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        if #available(iOS 12.0, *) {
            configuration.environmentTexturing = .automatic
        }
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - Focus Square

    func updateFocusSquare(isObjectVisible: Bool) {
        if (isObjectVisible && isHideSquare) || coachingOverlay.isActive {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
        }
        
        // Выполняйте отбрасывание лучей только тогда, когда отслеживание ARKit находится в хорошем состоянии.
        if let camera = session.currentFrame?.camera, case .normal = camera.trackingState,
            let query = sceneView.getRaycastQuery(),
            let result = sceneView.castRay(for: query).first {
            
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(raycastResult: result, camera: camera)
            }
            if !coachingOverlay.isActive {
                closeButton.isHidden = false
                restartButton.isHidden = false
                if isAdditingObject {
                    hideSquareButton.isHidden = false
                } else {
                    addButton.isHidden = false
                }
            }
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            closeButton.isHidden = true
            restartButton.isHidden = true
           // if isAdditingObject {
                hideSquareButton.isHidden = true
           // } else {
                addButton.isHidden = true
           // }
        }
    }

    @objc
    func didTapBackButton() {
        didTapRestartExperience()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func didTapAddButton() {
        updateObjectAvailability()
        virtualObjectSelectionViewController(self, didSelectObject: self.virtualObjects[0])
        addButton.isHidden = true
        hideSquareButton.isHidden = false
        isAdditingObject = true
    }
    
    @objc
    func didTapRestartExperience() {
        guard isRestartAvailable, !virtualObjectLoader.isLoading else { return }
        isRestartAvailable = false
        isAdditingObject = false
        isHideSquare = false
        
        hideSquareButton.tintColor = .white
        hideSquareButton.backgroundColor = UIColor.systemBlue
        
        virtualObjectLoader.removeAllVirtualObjects()

        resetTracking()

        // Отключите перезапуск на некоторое время, чтобы дать сеансу время для перезапуска.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
            self.closeButton.isHidden = false
            self.restartButton.isHidden = false
            if self.isAdditingObject {
                self.hideSquareButton.isHidden = false
            } else {
                self.addButton.isHidden = false
            }
        }
    }
    @objc
    func didTapHideSquare() {
        self.isHideSquare.toggle()
        if self.isHideSquare {
            self.hideSquareButton.backgroundColor = .white
            self.hideSquareButton.tintColor = .black
        } else {
            self.hideSquareButton.tintColor = .white
            self.hideSquareButton.backgroundColor = UIColor.systemBlue
        }
    }

}

extension ARVC {
    /** Добавляет указанный виртуальный объект в сцену, размещенный в позиции мирового пространства
         оценивается с помощью теста попадания из центра экрана.
         - - Тег: Разместить Виртуальный Объект */
    func placeVirtualObject(_ virtualObject: VirtualObject) {
        guard self.focusSquare.state != .initializing, let query = virtualObject.raycastQuery else {
            return
        }
        
        let trackedRaycast = createTrackedRaycastAndSet3DPosition(of: virtualObject, from: query,
            withInitialResult: virtualObject.mostRecentInitialPlacementResult)
        
        virtualObject.raycast = trackedRaycast
        virtualObjectInteraction.selectedObject = virtualObject
        virtualObject.isHidden = false
    }
    
    // - Tag: GetTrackedRaycast
    func createTrackedRaycastAndSet3DPosition(of virtualObject: VirtualObject,
        from query: ARRaycastQuery,
        withInitialResult initialResult: ARRaycastResult? = nil) -> ARTrackedRaycast? {
        if let initialResult = initialResult {
            self.setTransform(of: virtualObject, with: initialResult)
        }
        
        return session.trackedRaycast(query) { (results) in
            self.setVirtualObject3DPosition(results, with: virtualObject)
        }
    }
    
    func createRaycastAndUpdate3DPosition(of virtualObject: VirtualObject, from query: ARRaycastQuery) {
        guard let result = session.raycast(query).first else {
            return
        }
        
        if virtualObject.allowedAlignment == .any && self.virtualObjectInteraction.trackedObject == virtualObject {
            
            // Если перетаскивается объект, выровненный по поверхности, то
            // сгладьте его ориентацию, чтобы избежать видимых скачков, и применяйте только прямое перемещение.
            virtualObject.simdWorldPosition = result.worldTransform.translation
            
            let previousOrientation = virtualObject.simdWorldTransform.orientation
            let currentOrientation = result.worldTransform.orientation
            virtualObject.simdWorldOrientation = simd_slerp(previousOrientation, currentOrientation, 0.1)
        } else {
            self.setTransform(of: virtualObject, with: result)
        }
    }
    
    // - Tag: ProcessRaycastResults
    private func setVirtualObject3DPosition(_ results: [ARRaycastResult], with virtualObject: VirtualObject) {
        
        guard let result = results.first else {
            fatalError("Unexpected case: the update handler is always supposed to return at least one result.")
        }
        
        self.setTransform(of: virtualObject, with: result)
        
        // Если виртуального объекта еще нет в сцене, добавьте его.
        if virtualObject.parent == nil {
            self.sceneView.scene.rootNode.addChildNode(virtualObject)
            virtualObject.shouldUpdateAnchor = true
        }
        
        if virtualObject.shouldUpdateAnchor {
            virtualObject.shouldUpdateAnchor = false
            self.updateQueue.async {
                self.sceneView.addOrUpdateAnchor(for: virtualObject)
            }
        }
    }
    
    func setTransform(of virtualObject: VirtualObject, with result: ARRaycastResult) {
        virtualObject.simdWorldTransform = result.worldTransform
    }

    // MARK: - VirtualObjectSelectionViewControllerDelegate
    // - Tag: PlaceVirtualContent
    func virtualObjectSelectionViewController(_: ARVC, didSelectObject object: VirtualObject) {
        virtualObjectLoader.loadVirtualObject(object, loadedHandler: { [unowned self] loadedObject in
            
            do {
                let scene = try SCNScene(url: object.referenceURL, options: nil)
                self.sceneView.prepare([scene], completionHandler: { _ in
                    DispatchQueue.main.async {
                        self.hideObjectLoadingUI()
                        self.placeVirtualObject(loadedObject)
                    }
                })
            } catch {
                fatalError("Failed to load SCNScene from object.referenceURL")
            }
            
        })
        displayObjectLoadingUI()
        
    }
    
    func virtualObjectSelectionViewController(_: ProductVC, didDeselectObject object: VirtualObject) {
        guard let objectIndex = virtualObjectLoader.loadedObjects.firstIndex(of: object) else {
            fatalError("Programmer error: Failed to lookup virtual object in scene.")
        }
        virtualObjectLoader.removeVirtualObject(at: objectIndex)
        virtualObjectInteraction.selectedObject = nil
        if let anchor = object.anchor {
            session.remove(anchor: anchor)
        }
    }

    // MARK: Object Loading UI

    func displayObjectLoadingUI() {
        // Показать индикатор выполнения.
        //spinner.startAnimating()
        
        //closeButton.setImage(#imageLiteral(resourceName: "buttonring"), for: [])

        closeButton.isHidden = true
        addButton.isHidden = true
        
        message.startBlink()
        message.isHidden = false
        
        loadingIndicator.animateStroke()
        loadingIndicator.animateRotation()
        
        //closeButton.isEnabled = false
        isRestartAvailable = false
    }

    func hideObjectLoadingUI() {
        // Скрыть индикатор выполнения.
        //spinner.stopAnimating()

        //closeButton.setImage(UIImage(systemName: "arrowshape.turn.up.left.fill"), for: [])
        //closeButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])
        loadingIndicator.isAnimating = false
        
        message.startBlink()
        message.isHidden = true
        
        closeButton.isHidden = false
        addButton.isHidden = false
        

        //closeButton.isEnabled = true
        isRestartAvailable = true
    }
    
    func updateObjectAvailability() {
        // Обновляйте доступность объекта только в том случае, если последнее обновление было по крайней мере полсекунды назад.
        if let lastUpdateTimestamp = lastObjectAvailabilityUpdateTimestamp,
           let timestamp = sceneView.session.currentFrame?.timestamp,
           timestamp - lastUpdateTimestamp < 0.5 {
            return
        } else {
            lastObjectAvailabilityUpdateTimestamp = sceneView.session.currentFrame?.timestamp
        }
        
        var newEnabledVirtualObjectRows = Set<Int>()
        for (row, object) in VirtualObject.availableObjects.enumerated() {
            
            if let query = sceneView.getRaycastQuery(for: object.allowedAlignment),
               let result = sceneView.castRay(for: query).first {
                object.mostRecentInitialPlacementResult = result
                object.raycastQuery = query
                newEnabledVirtualObjectRows.insert(row)
            } else {
                object.mostRecentInitialPlacementResult = nil
                object.raycastQuery = nil
            }
        }
    }
}
