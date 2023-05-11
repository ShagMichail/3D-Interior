//
//  BasketView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 11.02.2023.
//

import UIKit
import SnapKit


protocol BasketViewDelegate: UITableViewDataSource, UITableViewDelegate {
    func didTapBackButton()
    func didTapArrangeButton()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}

final class BasketView: UIView {
    
    weak var delegate: BasketViewDelegate?
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "Ваш заказ"
        view.basketButton.removeFromSuperview()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var contentLabel: UILabel = {
        var label = UILabel()
        label.text = "Позиции:"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var table: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(BasketViewCell.self, forCellReuseIdentifier: BasketViewCell.identifier)
        table.backgroundColor = .systemGray2
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        return table
    }()
    
    lazy var emptyView = EmptyView()
    
    lazy var arrangeButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Оформить", for: .normal)
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
    
    required init(delegate: BasketViewDelegate) {
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
        setupElement()
        table.dataSource = delegate
        table.delegate = delegate
        self.delegate = delegate
        
        
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        arrangeButton.addTarget(self, action: #selector(didTapArrangeButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(contentLabel)
        addSubview(table)
        addSubview(arrangeButton)
        addSubview(emptyView)
        
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-10)
            //$0.bottom.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        table.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom)
            $0.bottom.equalTo(arrangeButton.snp.top).inset(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        arrangeButton.snp.makeConstraints {
            $0.top.equalTo(table.snp.bottom)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        
    }
    
        @objc func didTapArrangeButton() {
            delegate?.didTapArrangeButton()
        }
    
        @objc func didTapBackButton() {
            delegate?.didTapBackButton()
        }
    
}

