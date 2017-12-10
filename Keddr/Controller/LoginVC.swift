//
//  LoginVC.swift
//  Keddr
//
//  Created by macbook on 18.09.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit
import KeychainAccess
import Pinner

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
        view.backgroundColor = Color.ultraLightGray
        view.placeholder = "Имя пользователя"
        view.font = Font.date.create()
        view.clipsToBounds = true
        view.layer.opacity = 1
        view.layer.cornerRadius = 10
        view.keyboardType = UIKeyboardType.emailAddress
        view.delegate = self
        return view
    }()
    lazy var passwordField: CSTextField = { [unowned self] in
        let view = CSTextField()
        view.backgroundColor = Color.ultraLightGray
        view.placeholder = "Пароль"
        view.font = Font.date.create()
        view.clipsToBounds = true
        view.layer.opacity = 1
        view.layer.cornerRadius = 10
        view.isSecureTextEntry = true
        view.delegate = self
        return view
    }()
    lazy var signInButton: UIButton = { [unowned self] in
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
    lazy var signInLaterButton: UIButton = { [unowned self] in
        let view = UIButton(type: .system)
        view.setTitle("Войти позже", for: .normal)
        view.titleLabel?.font = Font.date.create()
        view.setTitleColor(Color.keddrYellow, for: .normal)
        view.addTarget(self, action: #selector(signInLaterButtonTapped), for: .touchUpInside)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNotifications()
        self.view.backgroundColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.setIsLoginScreenShown(value: true)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        adjustConstraints(for: newCollection)
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
        self.view.addSubview(signInLaterButton)
    
        logoView.makeConstraints(for: .top, .left, .right, .height) { (make) in
            make.pin(to: self.view.topAnchor, const: -20)
            make.pin(to: self.view.leftAnchor)
            make.pin(to: self.view.centerXAnchor)
            make.equal(100)
            
            self.compactHeightConstraints.append(contentsOf: make.returnAll())
            NSLayoutConstraint.deactivate(make.returnAll())
        }
        logoView.makeConstraints(for: .top, .left, .width, .height) { (make) in
            make.pin(to: self.view.centerYAnchor, const: -(self.view.frame.height * 2 / 5) + 50)
            make.pin(to: self.view.centerXAnchor, const: -50)
            make.equal(100)
            make.equal(100)
        }
        titleView.makeConstraints(for: .top, .left, .right) { (make) in
            make.pin(to: self.view.topAnchor, const: 40)
            make.pin(to: self.view.centerXAnchor)
            make.pin(to: self.view.rightAnchor)

            self.compactHeightConstraints.append(contentsOf: make.returnAll())
            NSLayoutConstraint.deactivate(make.returnAll())
        }
        titleView.makeConstraints(for: .top, .left, .right, .height) { (make) in
            make.pin(to: self.logoView.bottomAnchor, const: 20)
            make.pin(to: self.loginField.leftAnchor)
            make.pin(to: self.loginField.rightAnchor)
            make.equal(40)
            
            self.regularHeightConstraints.append(contentsOf: make.returnAll())
        }
        bottomContainerview.makeConstraints(for: .left, .bottom, .right, .height) { (make) in
            make.pin(to: self.view.leftAnchor)
            self.bottomContainerviewBottomConstraint = make.pinAndReturn(to: self.view.bottomAnchor)
            make.pin(to: self.view.rightAnchor)
            make.equal(200)
        }
        loginField.makeConstraints(for: .top, .centerX, .width, .height) { (make) in
            make.pin(to: self.bottomContainerview.centerYAnchor, const: -75)
            make.pin(to: self.bottomContainerview.centerXAnchor)
            make.equal(230)
            make.equal(30)
        }
        passwordField.makeConstraints(for: .top, .centerX, .width, .height) { (make) in
            make.pin(to: self.loginField.bottomAnchor, const: 30)
            make.pin(to: self.bottomContainerview.centerXAnchor)
            make.equal(230)
            make.equal(30)
        }
        signInButton.makeConstraints(for: .top, .centerX, .width, .height) { (make) in
            make.pin(to: self.passwordField.bottomAnchor, const: 30)
            make.pin(to: self.bottomContainerview.centerXAnchor)
            make.equal(100)
            make.equal(30)
        }
        signInLaterButton.makeConstraints(for: .left, .bottom, .width, .height) { (make) in
            make.pin(to: self.loginField.leftAnchor)
            make.pin(to: self.loginField.topAnchor, const: -20)
            make.equal(120)
            make.equal(30)
        }
    }
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func handleKeyboardNotifications(_ notification: Notification){
        guard let info = notification.userInfo else { return }
        if let endRect = info[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let beginRect = info[UIKeyboardFrameBeginUserInfoKey] as? CGRect {
            changeConstraintsForKeyboard(with: endRect, didShow: endRect.origin.y - beginRect.origin.y > 100)
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    func changeConstraintsForKeyboard(with rect: CGRect, didShow: Bool){
        if didShow {
            self.bottomContainerviewBottomConstraint?.constant = 0
        } else {
            self.bottomContainerviewBottomConstraint?.constant = -rect.height
        }
        if traitCollection.verticalSizeClass == .compact || traitCollection.horizontalSizeClass == .compact {
            if didShow {
                adjustConstraints(for: traitCollection)
            } else {
                NSLayoutConstraint.deactivate(regularHeightConstraints)
                NSLayoutConstraint.activate(compactHeightConstraints)
            }
        }
    }
    private func adjustConstraints(for collection: UITraitCollection){
        if collection.verticalSizeClass == .compact{
            NSLayoutConstraint.deactivate(regularHeightConstraints)
            NSLayoutConstraint.activate(compactHeightConstraints)
        } else {
            NSLayoutConstraint.activate(regularHeightConstraints)
            NSLayoutConstraint.deactivate(compactHeightConstraints)
        }
    }
    @objc func signInLaterButtonTapped(){
        dismiss(animated: true)
    }
    @objc func signInButtonTapped(){
        guard let login = loginField.text,
            let password = passwordField.text else { return }
        let user = User(login: login, password: password)
        CSActivityIndicator.startAnimating(in: self.view)
        AuthClient.signIn(with: user) { (error) in
            CSActivityIndicator.stopAnimating()
            if let error = error{
                CSAlertView.showAlert(with: error.userDescription, in: self.view)
            } else {
//                let userInfo = ["isSignedIn" : true ]
//                NotificationCenter.default.post(name: .UserStatusDidChange, object: nil, userInfo: userInfo)
//                let keychain = Keychain(service: "com.keddr.credentials")
//                print("signed in with:", keychain["uid"]!, keychain["login"]!, keychain["password"]!)
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










