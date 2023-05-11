//
//  ProductVCViewController.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 14.09.2022.
//

import UIKit
import ARKit
import Firebase


final class ProductVC: UIViewController {
    
    lazy var contentView = ProductView(delegate: self)
    
    private var product: ProductBasket
    private var isAdd = false
    
    var productsArray: StoresProduct = ProductDataStore()
    
    required init(
        product: ProductBasket,
        productsArray: StoresProduct = ProductDataStore.shared
    ) {
        self.product = product
        self.productsArray = productsArray
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupElement()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupTabBar()
        sendVerificationMail()
        isAdd = false
    }
    
    override func loadView() {
        view = contentView
    }
    
    private func setupTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
    }
    
    private func setupElement() {
        contentView.configure(with: product.product)
    }
    
    func sendVerificationMail() {
        if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified {
            contentView.headerView.basketButton.isHidden = false
            contentView.buyButton.backgroundColor = UIColor.systemBlue
            contentView.buyButton.setTitleColor(.white, for: .normal)
            contentView.buyButton.addTarget(self, action: #selector(didTapBuyButton), for: .touchUpInside)
        }
        else if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified == false {
            
            contentView.headerView.basketButton.isHidden = true
            contentView.buyButton.backgroundColor = UIColor.systemGray6
            contentView.buyButton.setTitleColor(.systemGray2, for: .normal)
            contentView.buyButton.addTarget(self, action: #selector(didTapEmailBuyButton), for: .touchUpInside)
            
        } else {
            contentView.headerView.basketButton.isHidden = true
            contentView.buyButton.backgroundColor = UIColor.systemGray6
            contentView.buyButton.setTitleColor(.systemGray2, for: .normal)
            contentView.buyButton.addTarget(self, action: #selector(didTapDeselectBuyButton), for: .touchUpInside)
        }
    }

    
    func setupNavBar(){
        navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func animateBasketButtun(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    @objc
    func didTapBuyButton() {
        productsArray.products.map { product in
            if product.product.name == self.product.product.name {
                product.count += 1
                isAdd = true
            }
        }
        if !isAdd {
            productsArray.products.append(product)
        }
        self.animateBasketButtun(contentView.headerView.basketButton)
    }
    
    @objc
    func didTapDeselectBuyButton() {
        let alert = UIAlertController(title: "Обратите внимание", message: "Чтобы совершать покупки, необходимо зарегистрироваться!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    func didTapEmailBuyButton() {
        let alert = UIAlertController(title: "Обратите внимание", message: "Почту подтвердили?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ProductVC: ProductViewDelegate {
    
    func didTapModelButton() {
        //dismiss(animated: true, completion: nil)
        var controller  = ARVC(name: product.product.nameModel)
        //controller.object =
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapBasketButton() {
        var controller = BasketVC()
        navigationController?.pushViewController(controller, animated: true)
    }
}
