//
//  ListView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 26.01.2023.
//

import UIKit
import SnapKit


protocol ListViewDelegate: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func didTapBasketButton()
}

final class ListView: UIView {
    
    weak var delegate: ListViewDelegate?
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "Категории"
        view.backButton.removeFromSuperview()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var table: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ListViewCell.self, forCellReuseIdentifier: ListViewCell.identifier)
        table.backgroundColor = .systemGray2
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        return table
    }()
    
    required init(delegate: ListViewDelegate) {
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
        table.dataSource = delegate
        table.delegate = delegate
        self.delegate = delegate
        headerView.basketButton.addTarget(self, action: #selector(didTapBasketButton), for: .touchUpInside)
        
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
//    private func setupElement() {
//        infoButton.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
//        contactButton.addTarget(self, action: #selector(didTapContactButton), for: .touchUpInside)
//    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(table)
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        table.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        
    }
    
    @objc func didTapBasketButton() {
        delegate?.didTapBasketButton()
    }
    
}
