//
//  BasketVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 11.02.2023.
//


import UIKit
import SnapKit

final class BasketVC: UIViewController {
    
    var productsArray: StoresProduct = ProductDataStore()
    
    lazy var contentView = BasketView(delegate: self)
    //    lazy var headerView: CustomHeader = {
    //        var view = CustomHeader()
    //        view.navTitle.text = "Категории"
    //        view.backButton.removeFromSuperview()
    //        view.backgroundColor = .systemBlue
    //        return view
    //    }()
    
//    let virtualObjectLoader = VirtualObjectLoader()
    //MARK: -
    
    required init(
        productsArray: StoresProduct = ProductDataStore.shared
    ) {
        self.productsArray = productsArray
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupNavBar()
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func loadView() {
        view = contentView
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupView() {
        tabBarController?.tabBar.backgroundImage = UIImage()
        if productsArray.products.count == 0 {
            contentView.table.isHidden = true
            contentView.emptyView.isHidden = false
        } else {
            contentView.table.isHidden = false
            contentView.emptyView.isHidden = true
        }
    }
    
}

//MARK: - Table View Delegate

extension BasketVC: BasketViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productsArray.products.count == 0 {
            contentView.table.isHidden = true
            contentView.emptyView.isHidden = false
        } else {
            contentView.table.isHidden = false
            contentView.emptyView.isHidden = true
        }
        return productsArray.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketViewCell.identifier, for: indexPath) as? BasketViewCell else { return UITableViewCell()}
        cell.delegate = self
        let item = productsArray.products[indexPath.row]
        cell.configure(score: indexPath.item + 1, indexPath: indexPath, data: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapArrangeButton() {
        var controller = MakingOrderVC(productsConfirm: productsArray.products)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension BasketVC: StepperDelegate {
    func zeroProduct(indexPath: IndexPath?) {
        let alert = UIAlertController(title: "Обратите внимание", message: "Вы точно хотите убрать этот товар из заказа?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel) { action in
            guard let indexPath = indexPath else { return }
            var product = self.productsArray.products[indexPath.item]
            self.productsArray.products.map { data in
                if data.product.name == product.product.name {
                    product.count = 1
                }
            }
            self.contentView.table.reloadRows(at: [indexPath], with: .automatic)
        })
        alert.addAction(UIAlertAction(title: "Да", style: .destructive) { action in
            guard let indexPath = indexPath else { return }
            var product = self.productsArray.products[indexPath.item]
            self.productsArray.products.map { data in
                if data.product.name == product.product.name {
                    product.count = 1
                }
            }
            self.productsArray.products.remove(at: indexPath.item)
            self.contentView.table.deleteRows(at: [indexPath], with: .left)
            self.contentView.table.reloadData()
        })
        self.present(alert, animated: true, completion: nil)
        print("zerro")
    }
}
