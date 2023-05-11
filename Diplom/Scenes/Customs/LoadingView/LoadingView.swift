//
//  LoadingView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 16.02.2023.
//

import UIKit
import SnapKit

final class LoadingView: UIView {
    
    lazy var isLoading: Bool = false
    
    lazy var loadingView: ProgressView = {
        let progress = ProgressView(colors: [.red, .systemGreen, .systemBlue], lineWidth: 5)
        return progress
    }()
    
    required init() {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews()
        makeConstraints()
        setupElement()
        
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(loadingView)
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        loadingView.snp.makeConstraints {
//            $0.top.equalTo(safeAreaLayoutGuide).inset(UIScreen.main.bounds.height / 2 - 50)
//            $0.leading.equalTo(safeAreaLayoutGuide).inset(UIScreen.main.bounds.width / 2 - 50)
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(50)

        }
    }
    
    private func setupElement() {
        loadingView.isAnimating = true
    }
}
