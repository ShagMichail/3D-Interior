//
//  HomeView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 27.01.2023.
//

import UIKit
import SnapKit

protocol HomeViewDelegate: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func numberOfSections(in tableView: UITableView) -> Int
}

final class HomeView: UIView {
    
    weak var delegate: HomeViewDelegate?
    
    lazy var isLoading: Bool = true
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "Интерьер"
        view.backButton.removeFromSuperview()
        view.basketButton.removeFromSuperview()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var loadingView: LoadingView = LoadingView()

    lazy var table: UITableView = {
        var table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FavoriteProductCell.self, forCellReuseIdentifier: FavoriteProductCell.identifier)
        table.register(NewCollectionCell.self, forCellReuseIdentifier: NewCollectionCell.identifier)
        table.register(DescriptionStylesCell.self, forCellReuseIdentifier: DescriptionStylesCell.identifier)
        table.backgroundColor = .systemGray2
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        return table
    }()
    
    required init(delegate: HomeViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        addSubviews()
        makeConstraints()
        table.dataSource = delegate
        table.delegate = delegate
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(table)
        addSubview(loadingView)
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
        
        loadingView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func isLoading(flag: Bool) {
        if !flag {
            loadingView.isHidden = true
        }
    }
}
