//
//  ResetPasswordVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit
import Firebase

final class ResetPasswordVC: UIViewController {
    
    lazy var contentView = ResetPasswordView(delegate: self, textFieldDelegat: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupTabBar()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func loadView() {
        view = contentView
    }
}

extension ResetPasswordVC: ResetPasswordDelegat {
    func resetButtonTapped(email: UITextField) {
        let email = email.text!
        if (!email.isEmpty){
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error == nil {
                    let alert = UIAlertController(title: "Проверьте", message: "Мы отправили вам письмо для смены вашего пароля. Больше не забывайте :)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    //если есть какая-то ошибка отправки сообщения
                    let alert = UIAlertController(title: "Ошибка", message: "Что-то не так. Попробуйте позже.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            
        }
    }
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension ResetPasswordVC: TextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

