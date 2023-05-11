//
//  GroopView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 26.01.2023.
//

import UIKit
import SnapKit

protocol GroopViewDelegate: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    func didTapBackButton()
    func didTapBasketButton()
    
}

final class GroopView: UIView {
    
    weak var delegate: GroopViewDelegate?
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ProductCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    required init(delegate: GroopViewDelegate) {
        super.init(frame: .zero)
        setupElement()
        addSubviews()
        makeConstraints()
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        self.delegate = delegate
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        headerView.basketButton.addTarget(self, action: #selector(didTapBasketButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(collectionView)
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(0)
            $0.bottom.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
    
    @objc func didTapBackButton() {
        delegate?.didTapBackButton()
    }
    
    @objc func didTapBasketButton() {
        delegate?.didTapBasketButton()
    }
    
}
