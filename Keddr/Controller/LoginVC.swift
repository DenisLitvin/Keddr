//
//  LoginVC.swift
//  Keddr
//
//  Created by macbook on 18.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
import KeychainAccess

class LoginVC: UIViewController{
    
    let backgroudView: UIImageView = {
        let view = UIImageView()
//        view.image = #imageLiteral(resourceName: "gradient")
        return view
    }()
    let logoView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "keddr_icon")
        view.contentMode = .scaleAspectFit
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel()
        view.text = "KEDDR.com"
        view.textAlignment = .center
        view.font = UIFont(name: "Helvetica-Bold", size: 24)
        view.textColor = Color.keddrYellow
        return view
    }()
    var bottomContainerviewTopConstraint: NSLayoutConstraint?
    var bottomContainerviewBottomConstraint: NSLayoutConstraint?
    let bottomContainerview: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let loginField: CSTextField = {
        let view = CSTextField()
        view.backgroundColor = .white
        view.placeholder = "Имя пользователя"
        view.font = Font.date.create()
        view.clipsToBounds = true
        view.layer.opacity = 1
        view.layer.borderWidth = 1
        view.layer.borderColor = Color.lightGray.cgColor
        view.layer.cornerRadius = 5
        view.keyboardType = UIKeyboardType.emailAddress
        return view
    }()
    let passwordField: CSTextField = {
        let view = CSTextField()
        view.backgroundColor = .white
        view.placeholder = "Пароль"
        view.font = Font.date.create()
        view.clipsToBounds = true
        view.layer.opacity = 1
        view.layer.borderWidth = 1
        view.layer.borderColor = Color.lightGray.cgColor
        view.layer.cornerRadius = 5
        view.isSecureTextEntry = true
        return view
    }()
    lazy var signInButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Войти", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.font = Font.description.create()
        view.backgroundColor = Color.keddrYellow
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return view
    }()
    lazy var backButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Позже", for: .normal)
        view.setTitleColor(Color.keddrYellow, for: .normal)
        view.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNotifications()
        self.view.backgroundColor = Color.darkGray
    }
    fileprivate func setupViews() {
        self.view.addSubview(logoView)
        self.view.addSubview(titleView)
        self.view.addSubview(bottomContainerview)
        bottomContainerview.addSubview(loginField)
        bottomContainerview.addSubview(passwordField)
        bottomContainerview.addSubview(signInButton)
        self.view.addSubview(backButton)
        
        logoView.anchor(top: self.view.centerYAnchor, left: self.view.centerXAnchor, bottom: nil, right: nil, topConstant: -(self.view.bounds.height * 2 / 5) + 50, leftConstant: -50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        titleView.anchor(top: logoView.bottomAnchor, left: loginField.leftAnchor, bottom: nil, right: loginField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        let bottomContainerViewConstraints = bottomContainerview.anchorWithReturnAnchors(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: (self.view.bounds.height * 3 / 5), leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bottomContainerviewTopConstraint = bottomContainerViewConstraints[0]
        bottomContainerviewBottomConstraint = bottomContainerViewConstraints[2]
        loginField.anchor(top: bottomContainerview.centerYAnchor, left: bottomContainerview.centerXAnchor, bottom: nil, right: nil, topConstant: -75, leftConstant: -100, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 30)
        passwordField.anchor(top: loginField.bottomAnchor, left: bottomContainerview.centerXAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: -100, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 30)
        signInButton.anchor(top: passwordField.bottomAnchor, left: bottomContainerview.centerXAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: -50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 30)
        backButton.anchor(top: topLayoutGuide.topAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 30)
    }
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    func handleKeyboardNotifications(_ notification: Notification){
        guard let info = notification.userInfo else { return }
        if let rect = info[UIKeyboardFrameEndUserInfoKey] as? CGRect{
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.bottomContainerviewTopConstraint?.constant = (self.view.bounds.height * 3 / 5) - rect.height
                self.bottomContainerviewBottomConstraint?.constant = -rect.height
                self.view.layoutIfNeeded()
            })
        }
    }
    func backButtonTapped(){
        dismiss(animated: true)
    }
    func signInButtonTapped(){
        guard let login = loginField.text,
            let password = passwordField.text else { return }
        let user = User(login: login, password: password)
        AuthClient.signIn(with: user) { (error) in
            if let error = error{
                print(error.userDescription)
            } else {
                let keychain = Keychain(service: "com.keddr.credentials")
                print("signed in with:", keychain["uid"]!, keychain["login"]!, keychain["password"]!)
                self.dismiss(animated: true)
            }
        }
    }
}










