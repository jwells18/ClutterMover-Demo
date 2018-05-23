//
//  CameraController.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import HMSegmentedControl

class CameraController: UIViewController, UIScrollViewDelegate, CameraScrollViewDelegate{
    
    private var job: DBJob!
    private var cameraScrollView = CameraScrollView()
    private var segmentedControl = HMSegmentedControl()
    
    init(job: DBJob) {
        self.job = job
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
    
    override func viewDidAppear(_ animated: Bool) {
        //Setup Navigation Title
        self.navigationItem.title = "photo".localized()
        cameraScrollView.setContentOffset(CGPoint(x: self.cameraScrollView.frame.width, y: 0), animated: false)
        segmentedControl.selectedSegmentIndex = 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Setup Navigation Title
        self.navigationItem.title = "photo".localized()
        cameraScrollView.setContentOffset(CGPoint(x: self.cameraScrollView.frame.width, y: 0), animated: false)
        segmentedControl.selectedSegmentIndex = 1
    }
    
    override var prefersStatusBarHidden: Bool {
        //Hide Status Bar
        return true
    }
    
    func setupNavigationBar(){
        //Setup Navigation Items
        let cancelButton = UIBarButtonItem(title: "cancel".localized(), style: .plain, target: self, action: #selector(self.cancelButtonPressed))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func setupView(){
        self.view.backgroundColor = .white

        //Setup Camera ScrollView
        self.setupCameraScrollView()
        
        //Setup SegmentedControl
        self.setupSegmentedControl()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupCameraScrollView(){
        cameraScrollView.delegate = self
        cameraScrollView.cameraView.cameraCaptureView.delegate = self
        cameraScrollView.cameraScrollViewDelegate = self
        cameraScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cameraScrollView)
    }
    
    func setupSegmentedControl(){
        segmentedControl = HMSegmentedControl(sectionTitles: photoCaptureOptions)
        segmentedControl.frame = CGRect(x: 0, y: 0, width: w, height: 50)
        segmentedControl.tintColor = .lightGray
        segmentedControl.selectionIndicatorColor = CLColor.primary
        segmentedControl.selectionIndicatorLocation = .none
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        segmentedControl.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.lightGray]
        segmentedControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16), NSForegroundColorAttributeName: CLColor.primary]
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(segmentedControl)
    }
    
    func setupConstraints(){
        let viewDict = ["cameraScrollView": cameraScrollView, "segmentedControl": segmentedControl] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cameraScrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentedControl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[cameraScrollView][segmentedControl(50)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //Segmented Control Delegate
    func segmentedControlChangedValue(segmentedControl: HMSegmentedControl){
        //Set CollectionView index to SegmentedControl index
        let index = segmentedControl.selectedSegmentIndex
        switch index {
        case 0:
            self.cameraScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.cameraScrollView.cameraView.cameraCaptureView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.navigationItem.title = "cameraRoll".localized()
            break
        case 1:
            self.cameraScrollView.setContentOffset(CGPoint(x: self.cameraScrollView.frame.width, y: 0), animated: true)
            self.cameraScrollView.cameraView.cameraCaptureView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.navigationItem.title = "photo".localized()
            break
        case 2:
            self.cameraScrollView.setContentOffset(CGPoint(x: self.cameraScrollView.frame.width, y: 0), animated: true)
            self.cameraScrollView.cameraView.cameraCaptureView.setContentOffset(CGPoint(x: self.cameraScrollView.cameraView.cameraCaptureView.frame.width, y: 0), animated: true)
            self.navigationItem.title = "video".localized()
            break
        default:
            break
        }
    }
    
    //ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width;
        let page = Int(scrollView.contentOffset.x / pageWidth);
        
        if(scrollView == self.cameraScrollView){
            //Change SegmentedControl index to match CollectionView index
            segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
        }
        else if(scrollView == self.cameraScrollView.cameraView.cameraCaptureView){
            //Change SegmentedControl index to match CollectionView index
            segmentedControl.setSelectedSegmentIndex(UInt(page+1), animated: true)
        }
        
        if(scrollView == self.cameraScrollView || scrollView == self.cameraScrollView.cameraView.cameraCaptureView){
            let index = segmentedControl.selectedSegmentIndex
            switch index {
            case 0:
                self.navigationItem.title = "cameraRoll".localized()
                break
            case 1:
                self.navigationItem.title = "photo".localized()
                break
            case 2:
                self.navigationItem.title = "video".localized()
                break
            default:
                break
            }
        }
    }
    
    //Camera ScrollView Delegate
    func didCaptureImage(image: UIImage){
        //Show Create Item Controller
        let createItemVC = CreateItemController(job: self.job, image: image)
        self.navigationController?.pushViewController(createItemVC, animated: true)
    }
    
    func didChooseLibraryPhoto(image: UIImage){
         //Show Create Item Controller
        let createItemVC = CreateItemController(job: self.job, image: image)
         self.navigationController?.pushViewController(createItemVC, animated: true)
    }
    
    //MARK: BarButtonItem Delegates
    func cancelButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}
