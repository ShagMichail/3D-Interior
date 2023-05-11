//
//  MakingOrderView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit
import SnapKit


protocol MakingOrderViewDelegate: AnyObject {
    func didTapBackButton()
    func didTapСonfirmButton()
}

final class MakingOrderView: UIView {
    
    weak var delegate: MakingOrderViewDelegate?
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "Ваш заказ"
        view.basketButton.removeFromSuperview()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        //scroll.frame = bounds
        //scroll.contentSize = contentCize
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = false
        scroll.showsVerticalScrollIndicator = false
//        scroll.clipsToBounds = true
        return scroll
    }()
    
    lazy var contentScrollView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        //view.frame.size = contentCize
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Подтвердить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.cornerRadius = 20
    
        return button
    }()
    
    lazy var allCell: [ScrollCell] = [] {
        didSet {
            setupElement()
        }
    }
    
    var resultCell: ResultCell? {
        didSet {
            setupElement()
        }
    }
    
    required init(delegate: MakingOrderViewDelegate) {
        super.init(frame: .zero)
        setupElement()
        self.delegate = delegate
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(didTapСonfirmButton), for: .touchUpInside)
        
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(scrollView)
        scrollView.addSubview(contentScrollView)
        allCell.forEach { cell in
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowRadius = 10
            cell.layer.cornerRadius = 20
            contentScrollView.addSubview(cell)
        }
        contentScrollView.addSubview(confirmButton)
        guard let cell = resultCell else { return }
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 10
        cell.layer.cornerRadius = 20
        contentScrollView.addSubview(cell)
        
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        contentScrollView.snp.makeConstraints {
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
            if !allCell.isEmpty {
                $0.height.equalTo((145*allCell.count)+200)
            }
//            if allCell.count == 2 {
//                $0.height.equalTo(390)
//            }
            
        }
        
        for i in allCell.indices {
            if i == 0 {
                allCell[i].snp.makeConstraints {
                    $0.top.equalTo(contentScrollView.snp.top).inset(20)
                    $0.leading.trailing.equalTo(contentScrollView).inset(15)
                    $0.height.equalTo(125)
                }
            } else {
                allCell[i].snp.makeConstraints {
                    $0.top.equalTo(allCell[i-1].snp.bottom).inset(-20)
                    $0.leading.trailing.equalTo(contentScrollView).inset(15)
                    $0.height.equalTo(125)
                }
            }
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(contentScrollView.snp.bottom).inset(20)
            $0.leading.trailing.equalTo(contentScrollView).inset(100)
            $0.height.equalTo(50)
            
        }
        
        guard let cell = resultCell else { return }
        cell.snp.makeConstraints {
            $0.bottom.equalTo(confirmButton.snp.top).inset(-20)
            $0.leading.trailing.equalTo(contentScrollView).inset(15)
            $0.height.equalTo(80)
        }
    }
    
    @objc func didTapСonfirmButton() {
        delegate?.didTapСonfirmButton()
    }
    
    @objc func didTapBackButton() {
        delegate?.didTapBackButton()
    }
    
}


