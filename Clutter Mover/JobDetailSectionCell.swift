//
//  JobDetailSectionCell.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class JobDetailSectionCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate{
    
    private let cellIdentifier = "cell"
    var tableView: UITableView!
    var job = DBJob()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        //Setup TableView
        self.setupTableView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupTableView(){
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = CLColor.faintGray
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(JobDetailCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
    }
    
    func setupConstraints(){
        let viewDict = ["tableView": tableView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(job: DBJob){
        self.job = job
        self.tableView.reloadData()
    }
    
    //UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobDetailKeys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! JobDetailCell
        cell.configure(key: jobDetailKeys[indexPath.row], job: self.job)
        return cell
    }
    
    //TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
