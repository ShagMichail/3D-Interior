//
//  StyleVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 21.02.2023.
//


import UIKit
import SDWebImage
import Firebase

final class StyleVC: UIViewController {
    
    private var products: [Product] = [] {
        didSet {
            contentView.collectionView.reloadData()
        }
    }
    
    private var idStyle: String = ""
    
    private let model: GroopVCModelDescription = GroopVCModel()
    
    private var imageLoader = ImageLoader.shared
    
    lazy var contentView = GroopView(delegate: self)
    
    required init(idStyle: String) {
        self.idStyle = idStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupModel()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        setupNavBar()
        sendVerificationMail()
    }
    
    override func loadView() {
        view = contentView
    }
    
    private func setupModel() {
        model.loadProducts()
        model.output = self
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.white
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func sendVerificationMail() {
        if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified {
            contentView.headerView.basketButton.isHidden = false
        }
        else {
            contentView.headerView.basketButton.isHidden = true
        }
    }
    
    private func setImage(for imageView: UIImageView, with name: String) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageLoader.getReference(with: name) { reference in
            reference.downloadURL { url, error in
              if let error = error {
                  imageView.image = UIImage(named: "logo.png")
              } else {
                  imageView.sd_setImage(with: url)
              }
            }
        }
    }
    
}


//MARK: -

extension StyleVC: GroopViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.3, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 15, left: 15, bottom: 50, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //        let viewController = ProductVC()
        //        let product = products[indexPath.row]
        //        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductCell else { return }
        //        let navigationController = UINavigationController(rootViewController: viewController)
        //        navigationController.pushViewController(viewController, animated: true)
        //present(navigationController, animated: true, completion: nil)
        guard let currentCell = collectionView.cellForItem(at: indexPath) as? ProductCell else { return }
        let product = products[indexPath.row]
        let rootVC = ProductVC(product: ProductBasket.init(product: product, count: 1))
        rootVC.contentView.productImage.image = currentCell.productImage.image
        rootVC.contentView.headerView.navTitle.text = currentCell.nameProductLabel.text
        navigationController?.pushViewController(rootVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        cell.configure(with: product)
        let imageView = cell.getImageView()
        let imageURL: UILabel = {
            let label = UILabel()
            label.text = product.name + ".jpeg"
            return label
        }()
        setImage(for: imageView, with: "Product/\(imageURL.text ?? "logo.jpeg")")
        return cell
    }
    
    func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func didTapBasketButton() {
        var controller = BasketVC()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension StyleVC: GroopVCInput {
    func didReceive(_ product: [Product]) {
        self.products = product.compactMap {
            if $0.idStyle == idStyle {
                return $0
            } else {
                return nil
            }
        }
    }
}
