//
//  LoginFooter.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol LoginFooterDelegate {
    func didPressShowPassword()
    func didPressForgotPassword()
    func didPressLogin()
}

class LoginFooter: UIView{
    
    var loginFooterDelegate: LoginFooterDelegate!
    var showPasswordIconButton = UIButton()
    var showPasswordButton = UIButton()
    var loginButton = UIButton()
    var forgotPasswordButton = UIButton()
    var loginActivityIndicator = UIActivityIndicatorView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = .white
        
        //Setup Show Password Icon Button
        showPasswordIconButton.setImage(UIImage(named: "uncheckedCircle"), for: .normal)
        showPasswordIconButton.backgroundColor = .white
        showPasswordIconButton.layer.cornerRadius = showPasswordIconButton.frame.width/2
        showPasswordIconButton.clipsToBounds = true
        showPasswordIconButton.addTarget(self, action: #selector(self.showPasswordButtonPressed), for: .touchUpInside)
        showPasswordIconButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(showPasswordIconButton)
        
        //Setup Show Password Button
        showPasswordButton.setTitle("showPassword".localized(), for: .normal)
        showPasswordButton.setTitleColor(.lightGray, for: .normal)
        showPasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        showPasswordButton.backgroundColor = .white
        showPasswordButton.addTarget(self, action: #selector(self.showPasswordButtonPressed), for: .touchUpInside)
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(showPasswordButton)
        
        //Setup Login Button
        loginButton.setTitle("logIn".localized(), for: .normal)
        loginButton.setTitleColor(.darkGray, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.backgroundColor = CLColor.faintGray
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        loginButton.isEnabled = false
        loginButton.addTarget(self, action: #selector(self.loginButtonPressed), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loginButton)
        
        //Setup Login ActivityIndicatorView
        loginActivityIndicator.activityIndicatorViewStyle = .white
        loginActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addSubview(loginActivityIndicator)
        
        //Setup Forgot Password Button
        forgotPasswordButton.setTitle("forgotPassword".localized(), for: .normal)
        forgotPasswordButton.setTitleColor(.darkGray, for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        forgotPasswordButton.backgroundColor = .white
        forgotPasswordButton.addTarget(self, action: #selector(self.forgotPasswordButtonPressed), for: .touchUpInside)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(forgotPasswordButton)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let viewDict = ["showPasswordIconButton": showPasswordIconButton, "showPasswordButton": showPasswordButton, "loginButton": loginButton, "forgotPasswordButton": forgotPasswordButton, "loginActivityIndicator": loginActivityIndicator] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[showPasswordIconButton(30)]-5-[showPasswordButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[loginButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[forgotPasswordButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.loginButton.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[loginActivityIndicator(30)]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[showPasswordIconButton(30)]-10-[loginButton(40)]-25-[forgotPasswordButton(40)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints([NSLayoutConstraint.init(item: showPasswordButton, attribute: .centerY, relatedBy: .equal, toItem: showPasswordIconButton, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: showPasswordButton, attribute: .height, relatedBy: .equal, toItem: showPasswordIconButton, attribute: .height, multiplier: 1, constant: 0)])
        self.loginButton.addConstraints([NSLayoutConstraint.init(item: loginActivityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.loginButton, attribute: .centerY, multiplier: 1, constant: 0)])
        self.loginButton.addConstraints([NSLayoutConstraint.init(item: loginActivityIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)])
    }
    
    func showPasswordButtonPressed(){
        self.loginFooterDelegate.didPressShowPassword()
    }
    
    func loginButtonPressed(){
        self.loginFooterDelegate.didPressLogin()
    }
    
    func forgotPasswordButtonPressed(){
        self.loginFooterDelegate.didPressForgotPassword()
    }
}

