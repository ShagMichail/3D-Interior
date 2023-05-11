//
//  ContsctVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 26.01.2023.
//

import UIKit

final class ContactVC: UIViewController {
    
    lazy var contentView = ContactView(delegate: self)
    
    var sheetController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupElement()
        // Do any additional setup after loading the view.
    }

    override func loadView() {
        view = contentView
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupElement() {
        sheetController.selectedDetentIdentifier = .medium
        sheetController.prefersGrabberVisible = true
        sheetController.detents = [
            .medium()
        ]
    }
}

extension ContactVC: ContactViewDelegate {
    func didTapButton() {
        let url: NSURL = URL(string: "TEL://+79166718071")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
}

