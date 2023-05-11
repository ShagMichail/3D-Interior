//
//  EditVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit
import Firebase


final class EditVC: UIViewController {
    
    private var user: User
//        didSet {
//            if !users.isEmpty {
//                contentView.configure(user: users[0])
//            }
//        }
//    }
    private let model: UserModelDescription = UserModel()
    //для форматирования строки телефона
    private let maxNumberCount = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    
    lazy var contentView = EditView(delegate: self, textFieldDelegat: self)
    
    required init(
        user: User
    ) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupTabBar()
        contentView.configure(user: user)
//        setupModel()
    }
    
    private func setupModel() {
//        model.loadUsers()
//        model.output = self
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
    
    public func sendVerificationMail() {
        if Auth.auth().currentUser != nil && !Auth.auth().currentUser!.isEmailVerified {
            Auth.auth().currentUser!.sendEmailVerification(completion: { (error) in
                //Сообщите пользователю, что письмо отправлено или не может быть отправлено из-за ошибки.
                if error != nil {
                    
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
    
    //для форматирования строки телефона
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "" }
        
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        if number.count == 1 {
            return "+" + "7"
        } else {
            return "+" + number
        }
    }
}

extension EditVC: EditViewDelegat {
    func editButtonTapped(name: UITextField, number: UITextField, city: UITextField) {
        if (!name.text!.isEmpty && !number.text!.isEmpty && !city.text!.isEmpty) {
            user.name = name.text!
            user.phone = number.text!
            user.city = city.text!
            model.update(user: user)
            name.text = " "
            number.text = " "
            city.text = " "
            //self.custumAlert.showAlert(title: "Ready", message: "Your data has been successfully updated", viewController: self)
//            setupNavBarHiden()
            navigationController?.popToRootViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

}

extension EditVC: TextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == contentView.numberTextField {
            let fullString = (textField.text ?? "") + string
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
            return false
        } else {
            return true
        }
    }
}

//extension EditVC: UserControllerInput {
//    func didReceive(_ users: [User]) {
//        self.users = users.compactMap {
//            if $0.id == Auth.auth().currentUser?.uid {
//                     return $0
//                 } else {
//                     return nil
//                 }
//             }
//    }
//}
