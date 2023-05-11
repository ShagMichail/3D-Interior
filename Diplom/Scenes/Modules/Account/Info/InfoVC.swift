//
//  InfoVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 26.01.2023.
//

import UIKit

final class InfoVC: UIViewController {
    
    lazy var contentView = InfoView(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        // Do any additional setup after loading the view.
    }
    

    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }

    override func loadView() {
        view = contentView
    }
}

extension InfoVC: InfoViewDelegate {
    func didTapMenuButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}
