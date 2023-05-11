//
//  MakingOrderVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit
import Firebase

final class MakingOrderVC: UIViewController {
    
    lazy var contentView = MakingOrderView(delegate: self)
    
    private var users: [User] = []
    private let model: UserModelDescription = UserModel()
    
    private var productsConfirm: [ProductBasket]
    private var allCell: [ScrollCell] = []
//    private var resultCell = ResultCell(product: <#[ProductBasket]#>)
    
    var productsArray: StoresProduct = ProductDataStore()
    
    required init(
        productsConfirm: [ProductBasket],
        productsArray: StoresProduct = ProductDataStore.shared
    ) {
        self.productsConfirm = productsConfirm
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
        makeCell()
        setupNavBar()
        setupModel()
    }
    
    override func loadView() {
        view = contentView
    }
    
    private func setupModel() {
        model.loadUsers()
        model.output = self
    }
    
    private func makeCell() {
        var index = 0
        productsConfirm.forEach { product in
            index += 1
            self.allCell.append(ScrollCell.init(product: product, sequenceNumber: index))
        }
        contentView.allCell = self.allCell
        var resultCell = ResultCell.init(product: productsConfirm)
        contentView.resultCell = resultCell
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
}

extension MakingOrderVC: MakingOrderViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapСonfirmButton() {
        let alert = UIAlertController(title: "Заказ сделан!", message: "Заказ поступил в обработку. В ближайшее врем с вами свяжуться для усточнения необходимой информации.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отлично!", style: .cancel) { action in
            self.productsArray.products = []
            self.users[0].countProcessing = "\((Int(self.users[0].countProcessing) ?? 0)+1)"
            self.model.update(user: self.users[0])
            self.navigationController?.popToRootViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
}

extension MakingOrderVC: UserControllerInput {
    func didReceive(_ users: [User]) {
        self.users = users.compactMap {
            if $0.id == Auth.auth().currentUser?.uid {
                return $0
            } else {
                return nil
            }
        }
    }
}
