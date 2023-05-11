//
//  HomeVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 13.09.2022.
//

import UIKit
import SDWebImage

enum Section {
    case collection(items: [NewCollection])
    case style(items: [Style])
    case product(items: [Product])
}

struct CellIdentifier {
    static var style = "DescriptionStylesCell"
    static var collection = "NewCollectionCell"
    static var product = "FavoriteProductCell"
}


protocol HomeVCInput: AnyObject {
    func didReceive(_ product: [Product])
    func didReceive(_ newCollection: [NewCollection])
    func didReceive(_ style: [Style])
}

final class HomeVC: UIViewController {
    
    private var product: [Product] = [] {
        didSet {
            dataSource = createDataSource()
            contentView.table.reloadData()
        }
    }
    
    private var newCollection: [NewCollection] = [] {
        didSet {
            dataSource = createDataSource()
            contentView.table.reloadData()
        }
    }
    
    private var style: [Style] = [] {
        didSet {
            dataSource = createDataSource()
            contentView.table.reloadData()
        }
    }
    
    private var imageLoader = ImageLoader.shared
    
    private let model: HomeVCModelDescription = HomeVCModel()
    
    private var isCollectionEnabled = true
    private var isStyleEnabled = true
    private var isProductEnabled = true
    
    private var dataSource = [Section]()
    
    lazy var contentView = HomeView(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModel()
        setupElement()
        contentView.isLoading(flag: true)
        dataSource = createDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupTabBar()
    }
    
    override func loadView() {
        view = contentView
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupModel() {
        model.loadProducts()
        model.loadNewCollections()
        model.loadStyls()
        model.output = self
    }
    
    private func setupElement() {
        view.backgroundColor = .red
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

extension HomeVC: HomeViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = dataSource[indexPath.section]
        
        switch section {
        case .collection:
            let collection = newCollection[indexPath.item]
            let rootVC = CollectionVC(idCollection: collection.id)
            rootVC.contentView.headerView.navTitle.text = collection.name
            navigationController?.pushViewController(rootVC, animated: true)
            
            
        case .style:
            let style = style[indexPath.item]
            let rootVC = StyleVC(idStyle: style.id)
            rootVC.contentView.headerView.navTitle.text = style.name
            navigationController?.pushViewController(rootVC, animated: true)
            
        case .product:
            guard let currentCell = tableView.cellForRow(at: indexPath) as? FavoriteProductCell else { return }
            let product = product[indexPath.item]
            let rootVC = ProductVC(product: ProductBasket(product: product, count: 1))
            rootVC.contentView.headerView.navTitle.text = product.name
            rootVC.contentView.productImage.image = currentCell.mainImageView.image
            navigationController?.pushViewController(rootVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource[indexPath.section]
        switch section {
        case .collection  : return 280
        case .style : return 200
        case .product    : return 200
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        switch dataSource[section] {
        case .collection(let items)  : return items.count
        case .style(let items) : return items.count
        case .product(let items)    : return items.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = dataSource[indexPath.section]
        
        switch section {
        case .collection(let items):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.collection,
                for: indexPath
            ) as? NewCollectionCell else { return UITableViewCell() }
            let item = items[indexPath.row]
            cell.configure(with: item)
            let imageView = cell.getImageView()
            let imageURL: UILabel = {
                let label = UILabel()
                label.text = item.name + ".jpeg"
                return label
            }()
            setImage(for: imageView, with: "Collection/\(imageURL.text ?? "logo.jpeg")")
            return cell
            
        case .style(let items):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.style,
                for: indexPath
            ) as? DescriptionStylesCell else { return UITableViewCell() }
            let item = items[indexPath.row]
            cell.configure(with: item)
            let imageView = cell.getImageView()
            let imageURL: UILabel = {
                let label = UILabel()
                if item.name.last == "й" {
                    label.text = String(item.name.dropLast()) + ".jpeg"
                } else {
                    label.text = item.name + ".jpeg"
                }
                return label
            }()
            setImage(for: imageView, with: "Style/\(imageURL.text ?? "logo.jpeg")")
            return cell
            
        case .product(let items):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.product,
                for: indexPath
            ) as? FavoriteProductCell else { return UITableViewCell() }
            let item = items[indexPath.row]
            cell.configure(with: item)
            let imageView = cell.getImageView()
            let imageURL: UILabel = {
                let label = UILabel()
                label.text = item.name + ".jpeg"
                return label
            }()
            setImage(for: imageView, with: "Product/\(imageURL.text ?? "logo.jpeg")")
            imageView.clipsToBounds = true
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        switch dataSource[section] {
        case .collection:
            return CustomHeaderSection(title: "Новый стиль", image: "star.leadinghalf.filled")
        case .style:
            return CustomHeaderSection(title: "Что, как и почему?", image: "list.bullet.rectangle.fill")
        case .product:
            return CustomHeaderSection(title: "Любимое", image: "heart.fill")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 2))
        header.backgroundColor = .black
        switch dataSource[section] {
        case .collection:
            return header
        case .style:
            return header
        case .product:
            return UILabel()
        }
    }
}

extension HomeVC: HomeVCInput {
    func didReceive(_ product: [Product]) {
        var products = product
        products.sort(by: { Int($0.countSold) ?? 0 > Int($1.countSold) ?? 0 })
        var result: [Product] = []
        for i in products.indices {
            if i <= 3 {
                result.append(products[i])
            } else {
                break
            }
        }
        self.product = result
    }
    
    func didReceive(_ newCollection: [NewCollection]) {
        self.newCollection = newCollection
    }
    
    func didReceive(_ style: [Style]) {
        self.style = style
        contentView.isLoading(flag: false)
    }
}

extension HomeVC {
    func createDataSource() -> [Section] {
        var sections = [Section]()
        
        if isCollectionEnabled {
            sections.append(Section.collection(items: newCollection))
        }
        
        if isStyleEnabled {
            sections.append(Section.style(items: style))
        }
        
        if isProductEnabled {
            sections.append(Section.product(items: product))
        }
        
        return sections
    }
}
