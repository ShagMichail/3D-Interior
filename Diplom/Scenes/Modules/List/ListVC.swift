//
//  ListVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 13.09.2022.
//

import UIKit
import SnapKit
import SDWebImage
import Firebase

protocol ListVCInput: AnyObject {
    func didReceive(_ room: [Room])
}

final class ListVC: UIViewController {

    
    //MARK: -
    private var rooms: [Room] = [] {
        didSet {
            contentView.table.reloadData()
        }
    }
    
//    private var idProducts: [String] = []
    
    private var flagAuth: Bool?
    
    private let model: ListVCModelDescription = ListVCModel()
    private var imageLoader = ImageLoader.shared
    
    lazy var contentView = ListView(delegate: self)
    
    let virtualObjectLoader = VirtualObjectLoader()
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupModel()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupTabBar()
        sendVerificationMail()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func loadView() {
        view = contentView
    }
    
    private func setupModel() {
        model.loadRooms()
        model.output = self
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupView() {
        tabBarController?.tabBar.backgroundImage = UIImage()
    }
    
    func sendVerificationMail() {
        if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified {
            flagAuth = true
            contentView.headerView.basketButton.isHidden = false
        }
        else {
            flagAuth = false
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

//MARK: - Table View Delegate

extension ListVC: ListViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !virtualObjectLoader.isLoading else { return }
        
        guard let currentCell = tableView.cellForRow(at: indexPath) as? ListViewCell else { return }
        let rootVC = GroopVC(
            idRooms: rooms[indexPath.row].id
        )
        rootVC.contentView.headerView.navTitle.text = currentCell.nameLabel.text
        navigationController?.pushViewController(rootVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView {
        return UILabel()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.identifier, for: indexPath) as? ListViewCell else { return UITableViewCell()}
        let room = rooms[indexPath.row]
        cell.configure(with: room)
        let imageView = cell.getImageView()
        let imageURL: UILabel = {
            let label = UILabel()
            label.text = room.name + ".jpeg"
            return label
        }()
        setImage(for: imageView, with: "Room/\(imageURL.text ?? "logo.jpeg")")
        return cell
    }
    
    func didTapBasketButton() {
        var controller = BasketVC()
        navigationController?.pushViewController(controller, animated: true)
    }
}


extension ListVC: ListVCInput {
    func didReceive(_ room: [Room]) {
        self.rooms = room
//        self.rooms = rooms.compactMap {
//                 if $0.idExhibition == nameExhibition {
//                     return $0
//                 } else {
//                     return nil
//                 }
//             }
         }
}
