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
    var bottomContainerviewBottomConstraint: NSLayoutConstraint?
    let bottomContainerview: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var loginField: CSTextField = { [unowned self] in
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
        view.delegate = self
        return view
    }()
    lazy var passwordField: CSTextField = { [unowned self] in
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
        view.delegate = self
        return view
    }()
    lazy var signInButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Войти", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.font = Font.signInButton.create()
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
        self.view.backgroundColor = Color.keddrBlack
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.setIsLoginScreenShown(value: true)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        changeConstraints(for: newCollection)
    }
    var regularHeightConstraints: [NSLayoutConstraint] = []
    var compactHeightConstraints: [NSLayoutConstraint] = []
    
    fileprivate func setupViews() {
        self.view.addSubview(logoView)
        self.view.addSubview(titleView)
        self.view.addSubview(bottomContainerview)
        bottomContainerview.addSubview(loginField)
        bottomContainerview.addSubview(passwordField)
        bottomContainerview.addSubview(signInButton)
        self.view.addSubview(backButton)
        
        regularHeightConstraints.append(contentsOf: logoView.anchorWithReturnAnchors(top: self.view.centerYAnchor, left: self.view.centerXAnchor, bottom: nil, right: nil, topConstant: -(self.view.frame.height * 2 / 5) + 50, leftConstant: -50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100))
        
        compactHeightConstraints.append(logoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -20))
        compactHeightConstraints.append(logoView.leftAnchor.constraint(equalTo: self.view.leftAnchor))
        compactHeightConstraints.append(logoView.rightAnchor.constraint(equalTo: self.view.centerXAnchor))
        compactHeightConstraints.append(logoView.heightAnchor.constraint(equalToConstant: 100))
        
        regularHeightConstraints.append(contentsOf: titleView.anchorWithReturnAnchors(top: logoView.bottomAnchor, left: loginField.leftAnchor, bottom: nil, right: loginField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40))
        
        compactHeightConstraints.append(titleView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40))
        compactHeightConstraints.append(titleView.leftAnchor.constraint(equalTo: self.view.centerXAnchor))
        compactHeightConstraints.append(titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor))
        
        let bottomContainerViewConstraints = bottomContainerview.anchorWithReturnAnchors(top: nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 200)
        bottomContainerviewBottomConstraint = bottomContainerViewConstraints[1]
        loginField.anchor(top: bottomContainerview.centerYAnchor, left: bottomContainerview.centerXAnchor, bottom: nil, right: nil, topConstant: -75, leftConstant: -115, bottomConstant: 0, rightConstant: 0, widthConstant: 230, heightConstant: 30)
        passwordField.anchor(top: loginField.bottomAnchor, left: bottomContainerview.centerXAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: -115, bottomConstant: 0, rightConstant: 0, widthConstant: 230, heightConstant: 30)
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
            changeConstraintsForHandlingKeyboard(with: rect)
            animateBottomContainer(with: self.view.bounds.height - rect.origin.y)
        }
    }
    func changeConstraintsForHandlingKeyboard(with rect: CGRect){
        if traitCollection.verticalSizeClass == .compact || traitCollection.horizontalSizeClass == .compact {
            if rect.origin.y
                == self.view.bounds.height {
                changeConstraints(for: traitCollection)
            } else {
                NSLayoutConstraint.deactivate(regularHeightConstraints)
                NSLayoutConstraint.activate(compactHeightConstraints)
            }
        }
    }
    private func changeConstraints(for collection: UITraitCollection){
        if collection.verticalSizeClass == .compact{
            NSLayoutConstraint.deactivate(regularHeightConstraints)
            NSLayoutConstraint.activate(compactHeightConstraints)
        } else {
            NSLayoutConstraint.activate(regularHeightConstraints)
            NSLayoutConstraint.deactivate(compactHeightConstraints)
        }
    }
    func animateBottomContainer(with constant: CGFloat){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.bottomContainerviewBottomConstraint?.constant = -constant
            self.view.layoutIfNeeded()
        })
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
extension LoginVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}










