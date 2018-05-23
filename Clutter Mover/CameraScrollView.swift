//
//  CameraScrollView.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol CameraScrollViewDelegate {
    func didCaptureImage(image: UIImage)
    func didChooseLibraryPhoto(image: UIImage)
}

class CameraScrollView: UIScrollView, CameraLibraryViewDelegate, CameraViewDelegate{
    
    var cameraScrollViewDelegate: CameraScrollViewDelegate!
    var cameraLibraryView: CameraLibraryView!
    var cameraView: CameraView!
    let camera = Camera()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = .white
        self.isPagingEnabled = true
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        
        //Configure Camera
        self.configureCamera()
        
        //Setup Camera LibraryView
        self.setupCameraLibraryView()
        
        //Setup CameraView
        self.setupCameraView()
        
        //Setup Constraints()
        self.setupConstraints()
    }
    
    func configureCamera() {
        camera.prepare {(error) in
            if let error = error {
                print(error)
            }
            else{
                try? self.camera.displayPreview(on: self.cameraView.cameraViewFinder)
                self.camera.flashMode = .off
                self.camera.currentCameraPosition = .rear
            }
        }
    }
    
    func setupCameraLibraryView(){
        cameraLibraryView = CameraLibraryView(frame: .zero)
        cameraLibraryView.cameraLibraryViewDelegate = self
        cameraLibraryView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cameraLibraryView)
    }
    
    func setupCameraView(){
        cameraView = CameraView(frame: .zero)
        cameraView.delegate = self
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cameraView)
    }
    
    func setupConstraints(){
        let viewDict = ["cameraLibraryView": cameraLibraryView, "cameraView": cameraView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cameraLibraryView][cameraView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints([NSLayoutConstraint.init(item: cameraLibraryView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: cameraView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)])
        //Height & Vertical Alignment
        self.addConstraints([NSLayoutConstraint.init(item: cameraLibraryView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: cameraLibraryView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: cameraView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: cameraView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)])
    }
    
    //Camera Delegates
    func toggleFlashButtonPressed(sender: UIButton){
        if camera.flashMode == .on {
            camera.flashMode = .off
            cameraView.toggleFlashButton.setImage(UIImage(named:"flashOff"), for: .normal)
        }
        else {
            camera.flashMode = .on
            cameraView.toggleFlashButton.setImage(UIImage(named:"flashOn"), for: .normal)
        }
    }
    
    func toggleCameraButtonPressed(sender: UIButton){
        do {
            try camera.switchCameras()
        }
        catch {
            print(error)
        }
    }
    
    //Camera Button Fuctions
    func captureImage() {
        camera.captureImage {(image, error) in
            if((image) != nil){
                self.cameraScrollViewDelegate.didCaptureImage(image: image!)
            }
        }
    }
    
    //Camera Library View Delegate
    func relayDidChooseLibraryPhoto(image: UIImage) {
        cameraScrollViewDelegate.didChooseLibraryPhoto(image: image)
    }
    
    //Camera Capture Delegate
    func didPressPhotoCaptureButton() {
        captureImage()
    }
    
    func didPressVideoCaptureButton() {
        captureImage()
    }
}
