//
//  CreateItemController.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import RealmSwift

class CreateItemController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate{
    
    var currentDBEmployee: DBEmployee!
    private var image: UIImage!
    private var job: DBJob!
    private var createItemHeader = CreateItemHeader()
    private var cellIdentifier = "cell"
    private var tableView: UITableView!
    
    init(job: DBJob, image: UIImage) {
        self.image = image
        self.job = job
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //Set Current User
        let employeeManager = EmployeeManager()
        currentDBEmployee = employeeManager.getCurrentDBEmployee()
        
        //Setup NavigationBar
        self.setupNavigationBar()
        
        //Setup View
        self.setupView()
    }
    
    override var prefersStatusBarHidden: Bool {
        //Hide Status Bar
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createItemHeader.itemDescriptionTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    func setupNavigationBar(){
        //Setup NavigationBar
        self.navigationItem.title = "newItem".localized()
        
        //Setup Navigation Items
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
        let addButton = UIBarButtonItem(title: "add".localized(), style: .plain, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func setupView(){
        //Setup Create Item Header
        self.setupCreateItemHeader()
        
        //Setup TableView
        self.setupTableView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupCreateItemHeader(){
        //Setup Create Item Header
        createItemHeader.configure(image: image, dbItem: nil)
        createItemHeader.itemDescriptionTextView.delegate = self
        createItemHeader.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(createItemHeader)
    }
    
    func setupTableView(){
        //Setup TableView
        tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
    }
    
    func setupConstraints(){
        let viewDict = ["createItemHeader": createItemHeader, "tableView": tableView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[createItemHeader]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[createItemHeader(125)][tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //TableView Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tagsSectionHeader = CLSectionHeader()
        return tagsSectionHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
    
    //TableView Delegates
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    //BarButtonItem Delegates
    func backButtonPressed(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func addButtonPressed(){
        //Create Item
        let item = InventoryItem()
        item.userId = self.job.customerId
        item.username = self.job.customerName
        //item.category = <- Entered by customer
        item.caption = createItemHeader.itemDescriptionTextView.text
        //item.tags = []
        item.status = .inTransitToStorage
        item.employeeId = currentDBEmployee.objectId
        item.jobId = self.job.objectId
        
        //Upload New Item
        let inventoryManager = InventoryManager()
        inventoryManager.create(inventoryItem: item, image: image) { (completed, itemData) in
            if completed{
                
            }
            else{
                
            }
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}
