//
//  JobController.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import HMSegmentedControl
import MapKit
import Firebase

class JobController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JobMapSectionCellDelegate, JobInventorySectionCellDelegate{
    
    var currentDBEmployee: DBEmployee!
    private var job: DBJob!
    private var ref: DatabaseReference!
    private var deleteButton: UIBarButtonItem!
    private var jobHeader = JobHeader()
    private var photoButton: CLCircularButton!
    private var inventoryItems = [InventoryItem]()
    private var itemsSelectedSet = Set<InventoryItem>()
    private let detailsCellIdentifier = "detailsCell"
    private let mapCellIdentifier = "mapCell"
    private let inventoryItemsCellIdentifier = "inventoryItemsCell"
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    init(job: DBJob) {
        self.job = job
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Current User
        let employeeManager = EmployeeManager()
        currentDBEmployee = employeeManager.getCurrentDBEmployee()
        
        //Setup NavigationBar
        self.setupNavigationBar()
        
        //Setup View
        self.setupView()
        
        //Download Data
        self.downloadData()
    }
    
    override var prefersStatusBarHidden: Bool {
        //Show Status Bar
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Show Navigation Bar
        self.navigationController?.isNavigationBarHidden = false

        //Remove Gray Hairline
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    deinit {
        //Detach all Firebase Observers
        self.ref.removeAllObservers()
    }
    
    func setupNavigationBar(){
        //Setup Navigation Title
        let titleView = CLTitleView(frame: CGRect(x: 0, y: 0, width: 200, height: 32))
        titleView.configure(job: self.job)
        self.navigationItem.titleView = titleView
        
        //Setup Navigation Items
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
        
        deleteButton = UIBarButtonItem(title: "delete".localized(), style: .plain, target: self, action: #selector(self.deleteButtonPressed))
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        
        //Setup JobHeader
        self.setupJobHeader()
        
        //Setup CollectionView
        self.setupCollectionView()
        
        //Setup Photo Button
        self.setupPhotoButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupJobHeader(){
        jobHeader = JobHeader(frame: .zero)
        jobHeader.segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        jobHeader.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(jobHeader)
    }
    
    func setupCollectionView(){
        collectionView.register(JobDetailSectionCell.self, forCellWithReuseIdentifier: detailsCellIdentifier)
        collectionView.register(JobMapSectionCell.self, forCellWithReuseIdentifier: mapCellIdentifier)
        collectionView.register(JobInventorySectionCell.self, forCellWithReuseIdentifier: inventoryItemsCellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
    }
    
    func setupPhotoButton(){
        photoButton = CLCircularButton(frame: CGRect.zero)
        photoButton.setImage(UIImage(named: "camera"), for: .normal)
        photoButton.addTarget(self, action: #selector(photoButtonPressed), for: .touchUpInside)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(photoButton)
    }
    
    func setupConstraints(){
        let viewDict = ["jobHeader": jobHeader, "collectionView": collectionView, "photoButton": photoButton] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[jobHeader]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[photoButton(60)]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[jobHeader(36)][collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[photoButton(60)]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func downloadData(){
        ref = Database.database().reference(withPath: inventoryDatabase).child(job.customerId)
        let query: DatabaseQuery = ref.queryOrdered(byChild: "jobId").queryEqual(toValue: job.objectId)
        query.observe(.value, with: { (snapshot) -> Void in
            self.inventoryItems.removeAll()
            let inventoryManager = InventoryManager()
            for child in snapshot.children{
                //Find Inventory Items for JobId
                let childSnapshot = child as? DataSnapshot
                let rawData = childSnapshot?.value as! NSDictionary
                let inventoryItem = inventoryManager.createInventoryItem(rawData: rawData)
                self.inventoryItems.insert(inventoryItem, at: 0)
            }
            
            self.setInventorySegmentedControlTitles()
            let mapIndexPath = IndexPath(item: 1, section: 0)
            self.collectionView.reloadItems(at: [mapIndexPath])
        })
    }
    
    func setInventorySegmentedControlTitles(){
        var sectionTitles = self.jobHeader.segmentedControl.sectionTitles
        if(inventoryItems.count > 0){
            sectionTitles?[1] = String(format: "%@ (%@)", jobHeaderTitles[1], String(inventoryItems.count))
        }
        else{
            sectionTitles = jobHeaderTitles
        }
        self.jobHeader.segmentedControl.sectionTitles = sectionTitles
    }
    
    //CollectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailsCellIdentifier, for: indexPath) as! JobDetailSectionCell
            cell.configure(job: self.job)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: inventoryItemsCellIdentifier, for: indexPath) as! JobInventorySectionCell
            cell.configure(items: self.inventoryItems, selectedItems: itemsSelectedSet)
            cell.jobInventorySectionCellDelegate = self
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapCellIdentifier, for: indexPath) as! JobMapSectionCell
            cell.configure(job: self.job)
            cell.jobMapSectionCellDelegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailsCellIdentifier, for: indexPath) as! JobDetailSectionCell
            return cell
        }
    }
    
    //CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func didPressDirectionsButton(sender: UIButton){
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
    
    func didPressInventoryCell(indexPath: IndexPath) {
        let inventoryItem = self.inventoryItems[indexPath.item]
        let inventoryItemDetailVC = InventoryItemDetailController(inventoryItem: inventoryItem)
        self.navigationController?.pushViewController(inventoryItemDetailVC, animated: true)
    }
    
    func didPressSelectButton(indexPath: IndexPath?) {
        if(indexPath != nil){
            let item = inventoryItems[(indexPath?.item)!]
            switch itemsSelectedSet.contains(item){
            case true:
                itemsSelectedSet.remove(item)
            case false:
                itemsSelectedSet.insert(item)
            }
            
            let inventorySection = IndexPath(item: 1, section: 0)
            let inventorySectionCell = collectionView.cellForItem(at: inventorySection) as? JobInventorySectionCell
            inventorySectionCell?.configure(items: inventoryItems, selectedItems: itemsSelectedSet)
            
           self.setDeleteButton()
        }
    }
    
    func setDeleteButton(){
        //Set Delete Button (if necessary)
        if(itemsSelectedSet.count > 0 && jobHeader.segmentedControl.selectedSegmentIndex == 1){
            deleteButton.title = String(format: "%@ %@", "delete".localized(), String(itemsSelectedSet.count))
            self.navigationItem.rightBarButtonItem = deleteButton
        }
        else{
            deleteButton.title = nil
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    //Segmented Control Delegate
    func segmentedControlChangedValue(segmentedControl: HMSegmentedControl){
        //Set CollectionView index to SegmentedControl index
        let indexPath = IndexPath(item: segmentedControl.selectedSegmentIndex, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        //Determine if delete button should be shown
        self.setDeleteButton()
    }
    
    //ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == self.collectionView){
            //Change SegmentedControl index to match CollectionView index
            let pageWidth = scrollView.frame.size.width;
            let page = Int(scrollView.contentOffset.x / pageWidth);
            jobHeader.segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
        }
    }
    
    //BarButtonItem Delegates
    func backButtonPressed(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func deleteButtonPressed(){
        let alert = UIAlertController(title: "areYouSure".localized(), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(format: "%@ %@", "yesDelete".localized(), String(itemsSelectedSet.count)), style: .default, handler: { (alertAction) in
            //Delete in Firebase and Realm
            let inventoryManager = InventoryManager()
            let inventoryItemsArray = Array(self.itemsSelectedSet)
            inventoryManager.deleteInventoryItems(inventoryItems: inventoryItemsArray, completionHandler: { (error) in
                if error != nil{
                    //Show Error Toast
                    let toastDict:[String: Any] = ["message": "error".localized()]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: presentToastNotification), object: nil, userInfo: toastDict)
                }
                else{
                    //Remove items from selected set
                    self.itemsSelectedSet.removeAll()
                    self.navigationItem.rightBarButtonItem = nil
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
    
    //Button Delegates
    func photoButtonPressed(){
        let cameraVC = CameraController(job: self.job)
        let navVC = NavigationController(rootViewController: cameraVC)
        self.present(navVC, animated: false, completion: nil)
    }

}
