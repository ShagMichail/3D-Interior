//
//  AccountVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 13.09.2022.
//

import UIKit
import Firebase

protocol UserControllerInput: AnyObject {
    func didReceive(_ users: [User])
}

final class AccountVC: UIViewController {
    
    
    lazy var contentView = AccountView(delegate: self)
    
    private var users: [User] = [] {
        didSet {
            if !users.isEmpty {
                contentView.userView.configure(user: users[0])
            }
        }
    }
    
//    private let user = Auth.auth().currentUser
    
    private let model: UserModelDescription = UserModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupTabBar()
        setupElement()
        sendVerificationMail()
        setupModel()
    }
    
    private func setupModel() {
        model.loadUsers()
        model.output = self
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func loadView() {
        view = contentView
    }
    
    private func setupElement() {
        contentView.entranceView.delegate = self
        contentView.userView.delegate = self
        contentView.emailView.delegate = self
    }
    
    func sendVerificationMail() {
        if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified {
            contentView.entranceView.isHidden = true
            contentView.userView.isHidden = false
            contentView.emailView.isHidden = true
        } else if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified == false {
            contentView.entranceView.isHidden = true
            contentView.userView.isHidden = true
            contentView.emailView.isHidden = false
        } else {
            contentView.entranceView.isHidden = false
            contentView.userView.isHidden = true
            contentView.emailView.isHidden = true
        }
    }
}

extension AccountVC: AccountViewDelegate {
    
    func didTapInfoButton() {
        let rootVC = InfoVC()
        navigationController?.pushViewController(rootVC, animated: true)
    }
    
    func didTapContactButton() {
        let rootVC = ContactVC()
        navigationController?.present(rootVC, animated: true)
    }
    
    func didTapBasketButton() {
        var controller = BasketVC()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension AccountVC: EntranceViewProtocol {
    
    func didTapButton() {
        let rootVC = LoginVC()
        navigationController?.pushViewController(rootVC, animated: true)
    }
}

extension AccountVC: UserControllerInput {
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

extension AccountVC: UserViewProtocol {
    func didTapExitButton() {
        let firebaseAutch = Auth.auth()
        do{
            try firebaseAutch.signOut()
            viewWillAppear(false)
            //navigationController?.popToRootViewController(animated: false)
        } catch _ as NSError {
            print("не вышел из аакаунта")
        }
    }
    
    func didTapEditButton() {
        let rootVC = EditVC(user: users[0])
        navigationController?.pushViewController(rootVC, animated: true)
    }
}

extension AccountVC: EmailViewProtocol {
    func didTapEmailButton() {
        if Auth.auth().currentUser != nil && !Auth.auth().currentUser!.isEmailVerified {
            Auth.auth().currentUser!.sendEmailVerification(completion: { (error) in
                //Сообщите пользователю, что письмо отправлено или не может быть отправлено из-за ошибки.
                if error != nil {
                    let alert = UIAlertController(title: "Ошибка!", message: "Мы не смогли отправить вам письмо. Попробуйте позже.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Добро пожаловать!", message: "Мы направили вам письмо. Подтвердите свой email и возвращайтесь!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        else {
            //Либо пользователь недоступен, либо пользователь уже верифицирован.
        }
    }
}
