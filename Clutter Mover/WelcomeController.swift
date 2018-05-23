//
//  WelcomeController.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/16/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController{
    
    private var backgroundImageView = UIImageView()
    private var mainLogoView = UIImageView()
    private var mainLogoLabel = UILabel()
    private var signupButton = UIButton()
    private var loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup View
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Hide Navigation Bar
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //Setup View
    func setupView(){
        self.view.backgroundColor = .white
        
        //Setup Background ImageView
        self.setupBackgroundImageView()
        
        //Setup Main Logo ImageView
        self.setupMainLogoView()
        
        //Setup Main Logo Label
        self.setupMainLogoLabel()
        
        //Setup Login Button
        self.setupLoginButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupBackgroundImageView(){
        backgroundImageView.image = UIImage(named: "stockPhoto1")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundImageView)
    }
    
    func setupMainLogoView(){
        mainLogoView.image = UIImage(named: "clutterLogoTeal")
        mainLogoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainLogoView)
    }
    
    func setupMainLogoLabel(){
        mainLogoLabel.text = "mover".localized()
        mainLogoLabel.textColor = .lightGray
        mainLogoLabel.textAlignment = .center
        mainLogoLabel.font = UIFont.boldSystemFont(ofSize: 45)
        mainLogoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainLogoLabel)
    }
    
    func setupLoginButton(){
        loginButton.backgroundColor = CLColor.primary
        loginButton.setTitle("logIn".localized(), for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loginButton)
    }
    
    func setupConstraints(){
        //Width & Horizontal Alignment
        self.view.addConstraints([NSLayoutConstraint.init(item: backgroundImageView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0)])
        self.view.addConstraints([NSLayoutConstraint.init(item: mainLogoView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.75, constant: 0)])
        self.view.addConstraints([NSLayoutConstraint.init(item: mainLogoView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)])
        self.view.addConstraints([NSLayoutConstraint.init(item: mainLogoLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)])
        self.view.addConstraints([NSLayoutConstraint.init(item: loginButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.85, constant: 0)])
        self.view.addConstraints([NSLayoutConstraint.init(item: loginButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)])
        //Height & Vertical Alignment
        self.view.addConstraints([NSLayoutConstraint.init(item: backgroundImageView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: 0)])
        self.view.addConstraints([NSLayoutConstraint.init(item: mainLogoView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.6, constant: 0)])
        self.view.addConstraints([NSLayoutConstraint.init(item: mainLogoView, attribute: .height, relatedBy: .equal, toItem: mainLogoView, attribute: .width, multiplier: 0.37, constant: 0)])
        self.view.addConstraints([NSLayoutConstraint.init(item: mainLogoLabel, attribute: .top, relatedBy: .equal, toItem: mainLogoView, attribute: .bottom, multiplier: 1, constant: 0)])
        self.view.addConstraints([NSLayoutConstraint.init(item: loginButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.8, constant: 0)])
        self.view.addConstraints([NSLayoutConstraint.init(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
    }
    
    //Button Delegates
    func loginButtonPressed(){
        let loginVC = LoginController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
