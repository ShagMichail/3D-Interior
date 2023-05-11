//
//  LoginVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 22.02.2023.
//

import UIKit
import Firebase

protocol TextFieldDelegate: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

final class LoginVC: UIViewController {
    
    
    lazy var contentLoginView = LoginView(delegate: self, textFieldDelegat: self)
    lazy var contentRegistrationView = RegistrationView(delegate: self, textFieldDelegat: self)
    
    //для форматирования строки телефона
    private let maxNumberCount = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    
    
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
        view = contentLoginView
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
}

extension LoginVC: GoToLogin {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func loginButtonTapped(email: UITextField, password: UITextField) {
        let email = email.text!
        let password = password.text!
        Auth.auth().signIn(withEmail: email, password: password) { (result,error) in
            if error != nil {
                print("loh")
                let alert = UIAlertController(title: "Ошибка", message: "Что-то не так с данными. Попробуйте поменять.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
                self.present(alert, animated: true, completion: nil)
            } else {
                let controller = self.navigationController?.parent
                if controller?.superclass?.description() == Optional<String>.some("UITabBarController") {
                    self.navigationController?.popToRootViewController(animated: false)
                }
                print("norm")
//                self.navigationController?.popToRootViewController(animated: false)
                
            }
            print("DEBUG: Handle login")
        }
    }
    
    func registrirtButtonTapped() {
        view = contentRegistrationView
    }
    
    func resetButtonTapped() {
        let controller = ResetPasswordVC()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension LoginVC: GoToRegistration {
    
    func loginButtonTapped() {
        view = contentLoginView
    }
    
    func registrationButtonTapped(name: UITextField,
                                  email: UITextField,
                                  password: UITextField,
                                  number: UITextField,
                                  city: UITextField) {
        let name = name.text!
        let email = email.text!
        let password = password.text!
        let number = number.text!
        let city = city.text!
        if (!name.isEmpty && !email.isEmpty && !password.isEmpty && !number.isEmpty && !city.isEmpty) {
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil{
                let alert = UIAlertController(title: "Обратите внимание", message: "Мы уже знаем о вашей почте. Может вы забыли пароль?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
                self.present(alert, animated: true, completion: nil)
            } else {
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: [
                    "name": name,
                    //"password": password,
                    "email": email,
                    "phone": number,
                    "city": city,
                    "id": result!.user.uid,
                    "countBuy": "0",
                    "countProcessing": "0"
                ]){ (error) in
                    if error != nil {
                        print("loh")
                    } else {
                        self.sendVerificationMail()
                        let controller = self.navigationController?.parent
                        if controller?.superclass?.description() == Optional<String>.some("UITabBarController") {
                            self.navigationController?.popToRootViewController(animated: false)
                        }
                    }
                }
            }
        }
        } else {
            let alert = UIAlertController(title: "Обратите внимание", message: "Не все поля были введены корректно!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension LoginVC: TextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == contentRegistrationView.numberTextField {
            let fullString = (textField.text ?? "") + string
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
            return false
        } else {
            return true
        }
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.activeTextField = textField
//    }
}
