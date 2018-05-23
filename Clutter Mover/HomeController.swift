//
//  HomeController.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import RealmSwift

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate, JobCellDelegate {
    
    var currentDBEmployee: DBEmployee!
    private var jobs: [DBJob]!
    private let cellIdentifier = "cell"
    private var navigationHeaderView: HomeHeaderView!
    private var isInitialDownload = true
    private var emptyTableViewLabel = UILabel()
    private var downloadingActivityView = UIActivityIndicatorView()
    private var tableView: UITableView!
    private var realmNotificationToken: NotificationToken? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Current Employee
        let employeeManager = EmployeeManager()
        currentDBEmployee = employeeManager.getCurrentDBEmployee()

        //Setup NavigationBar
        self.setupHeaderView()
        
        //Setup View
        self.setupView()

        //Download Data
        self.downloadData()
        
        // Observe Realm Notifications
        let realm = try! Realm()
        realmNotificationToken = realm.observe { notification, realm in
            self.currentDBEmployee = employeeManager.getCurrentDBEmployee()
            self.navigationHeaderView.configure(employee: self.currentDBEmployee, date: nil)
            self.refreshView()
        }
    }
    
    deinit{
        realmNotificationToken?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Hide Navigation Bar
        self.navigationController?.isNavigationBarHidden = true
        
        //Remove Gray Hairline
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupHeaderView(){
        //Setup Header View
        navigationHeaderView = HomeHeaderView(frame: .zero)
        navigationHeaderView.profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        navigationHeaderView.configure(employee: currentDBEmployee, date: nil)
        navigationHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navigationHeaderView)
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        
        //Setup TableView
        self.setupTableView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func refreshView(){
        self.downloadData()
    }
    
    func setupTableView(){
        //Setup TableView
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = CLColor.faintGray
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(JobCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        //Setup Downloading ActivityView
        downloadingActivityView.activityIndicatorViewStyle = .gray
        tableView.backgroundView = downloadingActivityView
        
        //Setup EmptyCollectionView
        emptyTableViewLabel.text = "emptyJobs".localized()
        emptyTableViewLabel.textColor = .lightGray
        emptyTableViewLabel.textAlignment = .center
        emptyTableViewLabel.font = UIFont.boldSystemFont(ofSize: 22)
        emptyTableViewLabel.numberOfLines = 0
    }
    
    func setupConstraints(){
        let viewDict = ["navigationHeaderView":navigationHeaderView, "tableView": tableView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[navigationHeaderView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[navigationHeaderView(100)][tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func downloadData(){
        //Start Downloading ActivityView
        if isInitialDownload{
            downloadingActivityView.startAnimating()
        }
        
        //Change Initial Download Bool
        isInitialDownload = false
        
        //Download Jobs
        let jobManager = JobManager()
        jobManager.loadJobs(uid: currentDBEmployee?.objectId ?? "", day:Date()) { (jobs) in
            //Stop Downloading ActivityView
            if(self.downloadingActivityView.isAnimating){
                self.downloadingActivityView.stopAnimating()
            }
            self.jobs = Array(jobs!)
            
            //Show Empty View (if necessary)
            if self.jobs.count > 0{
                self.tableView.backgroundView = nil
            }
            else{
                self.tableView.backgroundView = self.emptyTableViewLabel
            }
            
            self.tableView.reloadData()
        }
    }
    
    //UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch isInitialDownload{
        case true:
            return 0
        case false:
            return jobs.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! JobCell
        cell.jobCellDelegate = self
        let job = jobs[indexPath.row]
        cell.configure(job: job)
        return cell
    }
    
    //TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobVC = JobController(job: jobs[indexPath.row])
        self.navigationController?.pushViewController(jobVC, animated: true)
    }
    
    func didPressMapButton(sender: UIButton){
        let touchPoint = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: touchPoint)
        let job = jobs[(indexPath?.row)!]
        let location = CLLocation(latitude: job.latitude, longitude: job.longitude)
        let mapPreference = currentDBEmployee?.mapSource
        switch mapPreference{
        case _ where mapPreference == "apple":
            //Open Location in Apple Maps
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
            mapItem.openInMaps(launchOptions: nil)
            break
        case _ where mapPreference == "google":
            //Open Location in Google Maps
            let stringURL = String(format: "http://maps.google.com/maps?saddr=%g,%g", location.coordinate.latitude, location.coordinate.longitude)
            let url = URL(string: stringURL)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            break
        default:
            let alert = UIAlertController(title: "getDirections".localized(), message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "appleMaps".localized(), style: .default, handler: { (alertAction) in
                //Open Location in Apple Maps
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
                mapItem.openInMaps(launchOptions: nil)
            }))
            alert.addAction(UIAlertAction(title: "googleMaps".localized(), style: .default, handler: { (alertAction) in
                //Open Location in Google Maps
                let stringURL = String(format: "http://maps.google.com/maps?saddr=%g,%g", location.coordinate.latitude, location.coordinate.longitude)
                let url = URL(string: stringURL)
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: { (alertAction) in
                
            }))
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = CGRect(x: sender.frame.width/2, y: sender.frame.height, width: CGFloat(1), height: CGFloat(1))
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    
    //Button Delegate
    func profileButtonPressed(){
        let profileVC = ProfileController()
        let navVC = NavigationController(rootViewController: profileVC)
        self.present(navVC, animated: true, completion: nil)
    }
}

