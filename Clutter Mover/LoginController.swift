//
//  LoginController.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift

class LoginController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, LoginFooterDelegate{
    
    private var cellIdentifier = "cell"
    private var tableView: UITableView!
    private var tableViewFooter: LoginFooter!
    private var isHidePassword = true
    private var emailString = String()
    private var passwordString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup NavigationBar
        self.setupNavigationBar()
        
        //Setup View
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Show Navigation Bar
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    //Setup NavigationBar
    func setupNavigationBar(){
        //Setup NavigationBar
        self.navigationItem.title = "logIn".localized()
        
        //Setup Navigation Items
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    //Setup View
    func setupView(){
        self.view.backgroundColor = .white
        
        //Setup TapToResign Gesture Recognizer
        self.setupTapToResignGestureRecognizer()
        
        //Setup TableView
        self.setupTableView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupTapToResignGestureRecognizer(){
        let tapToResignGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.resignTextFields))
        tapToResignGestureRecognizer.numberOfTapsRequired = 1
        tapToResignGestureRecognizer.numberOfTouchesRequired = 1
        tapToResignGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapToResignGestureRecognizer)
    }
    
    func setupTableView(){
        //Setup Notifications TableView
        tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.alwaysBounceVertical = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CLInputCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(tableView)
        
        //Setup TableView Footer
        tableViewFooter = LoginFooter(frame: .zero)
        tableViewFooter.frame.size.height = 165
        tableViewFooter.loginFooterDelegate = self
        tableView.tableFooterView = tableViewFooter
    }
    
    func setupConstraints(){
        let viewDict = ["tableView": tableView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[tableView]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //TableView Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CLInputCell
        cell.textField.delegate = self
        cell.textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        switch(indexPath.row){
        case 0:
            cell.textFieldLabel.text = "email".localized()
            cell.textField.placeholder = "enterEmail".localized()
            cell.textField.keyboardType = .emailAddress
            return cell
        case 1:
            cell.textFieldLabel.text = "password".localized()
            cell.textField.placeholder = "enterPassword".localized()
            cell.textField.isSecureTextEntry = isHidePassword
            cell.textField.keyboardType = .default
            return cell
        default:
            return cell
        }
    }
    
    //TextField Delegates
    func textFieldDidChange(textField: UITextField) {
        if(textField.placeholder == "enterEmail".localized()) {
            emailString = textField.text!
        }
        else if(textField.placeholder == "enterPassword".localized()){
            passwordString = textField.text!
        }
        
        //Validate Email & Password
        if(self.isValidEmail(testStr: emailString) && passwordString.characters.count >= 6){
            //Enable Login Button
            tableViewFooter.loginButton.isEnabled = true
            tableViewFooter.loginButton.backgroundColor = CLColor.primary
            tableViewFooter.loginButton.setTitleColor(.white, for: .normal)
        }
        else{
            tableViewFooter.loginButton.isEnabled = false
            tableViewFooter.loginButton.backgroundColor = CLColor.faintGray
            tableViewFooter.loginButton.setTitleColor(.darkGray, for: .normal)
        }
    }
    
    //Validation Methods
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        if(testStr != "password" && (testStr?.characters.count)! >= 6){
            return true
        }
        else{
            return false
        }
    }
    
    //TableView Footer Delegates
    func didPressShowPassword() {
        let indexPath = NSIndexPath.init(row: 1, section: 0)
        let cell: CLInputCell = tableView.cellForRow(at: indexPath as IndexPath) as! CLInputCell
        
        switch(isHidePassword){
        case true:
            isHidePassword = false
            tableViewFooter.showPasswordIconButton.setImage(UIImage(named: "checkedCircle"), for: .normal)
            break
        case false:
            isHidePassword = true
            tableViewFooter.showPasswordIconButton.setImage(UIImage(named: "uncheckedCircle"), for: .normal)
            break
        }
        
        cell.textField.isSecureTextEntry = isHidePassword
        cell.textField.becomeFirstResponder()
    }
    
    func didPressLogin() {
        tableViewFooter.loginActivityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: emailString, password: passwordString) { (user, error) in
            if(error == nil){
                //Go to Home - automatically triggered by user state observer in App Delegate
                self.tableViewFooter.loginActivityIndicator.stopAnimating()
                
                //Show Welcome Back Toast
                let toastDict:[String: Any] = ["message": "welcomeBack".localized()]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: presentToastNotification), object: nil, userInfo: toastDict)
            }
            else{
                //Show Error Message
                self.tableViewFooter.loginActivityIndicator.stopAnimating()
                
                var message = "error".localized()
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        message = "invalidEmail".localized()
                    case .userDisabled:
                        message = "accountDisabled".localized()
                    case .wrongPassword:
                        message = "incorrectPassword".localized()
                    default:
                        break
                    }
                }
                
                //Show Error Toast
                let toastDict:[String: Any] = ["message": message]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: presentToastNotification), object: nil, userInfo: toastDict)
            }
        }
    }
    
    func didPressForgotPassword() {
        //Show Reset Alert Controller
        let alert = UIAlertController(title: "resetPassword".localized(), message: "resetPasswordInstructions".localized(), preferredStyle: .alert)
        var emailTextField: UITextField!
        alert.addTextField { (textField : UITextField!) -> Void in
            emailTextField = textField
            textField.placeholder = "emailAddress".localized()
        }
        let sendAction = UIAlertAction(title: "send".localized(), style: .default, handler: { alert -> Void in
            let emailString = emailTextField.text
            
            if(self.isValidEmail(testStr: emailString!)){
                Auth.auth().sendPasswordReset(withEmail: emailString!) { (error) in
                    if((error) != nil){
                        //Show Error Toast
                        let toastDict:[String: Any] = ["message": "errorTryAgain".localized()]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: presentToastNotification), object: nil, userInfo: toastDict)
                    }
                    else{
                        //Show Error Toast
                        let toastDict:[String: Any] = ["message": "passwordResetSent".localized()]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: presentToastNotification), object: nil, userInfo: toastDict)
                    }
                }
            }
            else{
                //Show Error Toast
                let toastDict:[String: Any] = ["message": "errorTryAgain".localized()]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: presentToastNotification), object: nil, userInfo: toastDict)
            }
        })
        alert.addAction(sendAction)
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Gesture Recognizer Delegates
    func resignTextFields(sender: UITapGestureRecognizer){
        if (sender.state == .ended){
            //Resign all textFields
            self.view.endEditing(true)
        }
    }
    
    //BarButtonItem Delegate
    func backButtonPressed(){
        _ = self.navigationController?.popViewController(animated: true)
    }
}
