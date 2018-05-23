//
//  ProfileController.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class ProfileController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    var currentDBEmployee: DBEmployee!
    private var realmNotificationToken: NotificationToken? = nil
    private var employeeManager = EmployeeManager()
    private let cellIdentifier = "cell"
    private var profileHeader: ProfileHeader!
    private var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Current Employee
        currentDBEmployee = employeeManager.getCurrentDBEmployee()
        
        //Setup NavigationBar
        self.setupNavigationBar()
        
        //Setup View
        self.setupView()
        
        // Observe Realm Notifications
        let realm = try! Realm()
        realmNotificationToken = realm.observe { notification, realm in
            self.currentDBEmployee = self.employeeManager.getCurrentDBEmployee()
            self.refreshView()
        }
    }
    
    deinit{
        realmNotificationToken?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Remove Gray Hairline
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupNavigationBar(){
        //Setup Navigation Items
        let cancelButton = UIBarButtonItem(image: UIImage(named: "cancel"), style: .plain, target: self, action: #selector(self.cancelButtonPressed))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        
        //Setup Profile Header
        self.setupProfileHeader()
        
        //Setup TableView
        self.setupTableView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func refreshView(){
        profileHeader.configure(employee: currentDBEmployee)
        self.tableView.reloadData()
    }
    
    func setupProfileHeader(){
        //Setup TableView Header
        profileHeader = ProfileHeader(frame: .zero)
        profileHeader.configure(employee: currentDBEmployee)
        profileHeader.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(profileHeader)
    }
    
    func setupTableView(){
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = CLColor.faintGray
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = CLColor.faintGray
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(CLSettingsCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
    }
    
    func setupConstraints(){
        let viewDict = ["profileHeader": profileHeader, "tableView": tableView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[profileHeader]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[profileHeader(140)][tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return settingsTitles0.count
        case 1:
            return settingsTitles1.count
        case 2:
            return settingsTitles2.count
        case 3:
            return settingsTitles3.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 35
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CLSettingsCell
        switch indexPath.section{
        case 0:
            switch indexPath.row {
            case 0:
                cell.configure(image: settingsImages0[indexPath.row], title: settingsTitles0[indexPath.row].localized(), subTitle: currentDBEmployee?.email, hideAccessoryView: true)
                break
            default:
                var birthdayString = ""
                if(currentDBEmployee?.birthday != nil){
                    birthdayString = (currentDBEmployee?.birthday)!.dateValue().monthAndDay()!
                }
                cell.configure(image: settingsImages0[indexPath.row], title: settingsTitles0[indexPath.row].localized(), subTitle: birthdayString, hideAccessoryView: true)
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.configure(image: settingsImages1[indexPath.row], title: settingsTitles1[indexPath.row].localized(), subTitle: currentDBEmployee?.team, hideAccessoryView: true)
                break
            case 1:
                cell.configure(image: settingsImages1[indexPath.row], title: settingsTitles1[indexPath.row].localized(), subTitle: currentDBEmployee?.coach, hideAccessoryView: true)
                break
            default:
                break
            }
        case 2:
            cell.configure(image: settingsImages2[indexPath.row], title: settingsTitles2[indexPath.row].localized(), subTitle: currentDBEmployee?.mapSource.localized(), hideAccessoryView: false)
            break
        case 3:
            cell.configure(image: settingsImages3[indexPath.row], title: settingsTitles3[indexPath.row].localized(), subTitle: nil, hideAccessoryView: false)
            break
        default:
            break
        }
        return cell
    }
    
    //TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            break
        case 1:
            break
        case 2:
            //Map Preference
            let alert = UIAlertController(title: "mapPreference".localized(), message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: { (alertAction) in
                
            }))
            alert.addAction(UIAlertAction(title: "googleMaps".localized(), style: .default, handler: { (alertAction) in
                self.employeeManager.updateEmployee(data: ["mapSource": "google"])
            }))
            alert.addAction(UIAlertAction(title: "appleMaps".localized(), style: .default, handler: { (alertAction) in
                self.employeeManager.updateEmployee(data: ["mapSource": "apple"])
            }))
            alert.addAction(UIAlertAction(title: "noPreference".localized(), style: .default, handler: { (alertAction) in
                self.employeeManager.updateEmployee(data: ["mapSource": "noMapPreference"])
            }))
            let cell = tableView.cellForRow(at: indexPath) as! CLSettingsCell
            alert.popoverPresentationController?.sourceView = cell
            alert.popoverPresentationController?.sourceRect = CGRect(x: cell.frame.width/2, y: cell.frame.height, width: CGFloat(1), height: CGFloat(1))
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            self.present(alert, animated: true, completion: nil)
            break
        case 3:
            switch indexPath.row{
            case 0:
                //Help
                let alert = UIAlertController(title: "help".localized(), message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: { (alertAction) in
                    
                }))
                alert.addAction(UIAlertAction(title: "helpWebsite".localized(), style: .default, handler: { (alertAction) in
                    let url = URL(string: "helpURL".localized())!
                    let webViewVC = CLWebViewController(url: url)
                    self.navigationController?.pushViewController(webViewVC, animated: true)
                }))
                alert.addAction(UIAlertAction(title: "customerService".localized(), style: .default, handler: { (alertAction) in
                    //Contact Us
                    if let url = URL(string: "tel://\(customerServicePhoneNumber)"), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }))
                let cell = tableView.cellForRow(at: indexPath) as! CLSettingsCell
                alert.popoverPresentationController?.sourceView = cell 
                alert.popoverPresentationController?.sourceRect = CGRect(x: cell.frame.width/2, y: cell.frame.height, width: CGFloat(1), height: CGFloat(1))
                alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
                self.present(alert, animated: true, completion: nil)
                break
            case 1:
                //Log Employee Out
                let alert = UIAlertController(title: "logOut?".localized(), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: { (alertAction) in
                    
                }))
                alert.addAction(UIAlertAction(title: "yes".localized(), style: .default, handler: { (alertAction) in
                    self.employeeManager.signOutEmployee()
                }))
                self.present(alert, animated: true, completion: nil)
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    //MARK: BarButtonItem Delegates
    func cancelButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}
