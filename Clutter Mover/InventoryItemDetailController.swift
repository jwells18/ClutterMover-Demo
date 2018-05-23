//
//  InventoryItemDetailController.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/18/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class InventoryItemDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private var inventoryItem: InventoryItem!
    private let cellIdentifier = "cell"
    private var tableView: UITableView!
    private var tableViewHeader: InventoryItemDetailHeader!
    
    init(inventoryItem: InventoryItem) {
        self.inventoryItem = inventoryItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup NavigationBar
        self.setupNavigationBar()
        
        //Setup View
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Show Gray Hairline
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    func setupNavigationBar(){
        //Set Navigation Title
        self.navigationItem.title = "item".localized()
        
        //Setup Navigation Items
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
        
        let deleteButton = UIBarButtonItem(title: "delete".localized(), style: .plain, target: self, action: #selector(self.deleteButtonPressed))
        self.navigationItem.rightBarButtonItem = deleteButton
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        
        //Setup TableView
        self.setupTableView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupTableView(){
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = CLColor.faintGray
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(InventoryItemDetailCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        //Setup TableView Header
        tableViewHeader = InventoryItemDetailHeader(frame: .zero)
        tableViewHeader.frame.size.height = 200
        tableViewHeader.configure(item: self.inventoryItem)
        tableView.tableHeaderView = tableViewHeader
    }
    
    func setupConstraints(){
        let viewDict = ["tableView": tableView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventoryItemDetailKeys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! InventoryItemDetailCell
        cell.configure(key: inventoryItemDetailKeys[indexPath.row], item: self.inventoryItem)
        return cell
    }
    
    //MARK: BarButtonItem Delegates
    func backButtonPressed(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func deleteButtonPressed(){
        let alert = UIAlertController(title: "areYouSure".localized(), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "yesDelete".localized(), style: .default, handler: { (alertAction) in
            //Delete in Firebase and Realm
            let inventoryManager = InventoryManager()
            let inventoryItemsArray: [InventoryItem] = [self.inventoryItem]
            inventoryManager.deleteInventoryItems(inventoryItems: inventoryItemsArray, completionHandler: { (error) in
                _ = self.navigationController?.popViewController(animated: true)
                if error != nil{
                    //Show Error Toast
                    let toastDict:[String: Any] = ["message": "error".localized()]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: presentToastNotification), object: nil, userInfo: toastDict)
                }
                else{
                    //Show Toast
                    let toastDict:[String: Any] = ["message": "itemsDeleted".localized()]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: presentToastNotification), object: nil, userInfo: toastDict)
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: { (alertAction) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
