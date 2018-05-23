//
//  CameraView.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol CameraViewDelegate: class {
    func toggleFlashButtonPressed(sender: UIButton)
    func toggleCameraButtonPressed(sender: UIButton)
    func didPressPhotoCaptureButton()
    func didPressVideoCaptureButton()
}

class CameraView: UIView{
    
    var cameraViewFinder: UIView!
    var toggleCameraButton: UIButton!
    var toggleFlashButton: UIButton!
    var cameraCaptureView: CameraCaptureView!
    var delegate: CameraViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = .black
        
        //Setup Camera View Finder
        cameraViewFinder = UIView(frame: .zero)
        cameraViewFinder.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cameraViewFinder)
        
        //Setup Flash Button
        toggleFlashButton = UIButton(frame: .zero)
        toggleFlashButton.setImage(UIImage(named: "flashOff"), for: .normal)
        toggleFlashButton.addTarget(self, action: #selector(toggleFlashButtonPressed), for: .touchUpInside)
        toggleFlashButton.tintColor = .white
        toggleFlashButton.translatesAutoresizingMaskIntoConstraints = false
        self.cameraViewFinder.addSubview(toggleFlashButton)
        
        //Setup Previous Button
        toggleCameraButton = UIButton(frame: .zero)
        toggleCameraButton.setImage(UIImage(named: "toggleCamera"), for: .normal)
        toggleCameraButton.addTarget(self, action: #selector(toggleCameraButtonPressed), for: .touchUpInside)
        toggleCameraButton.tintColor = .white
        toggleCameraButton.translatesAutoresizingMaskIntoConstraints = false
        self.cameraViewFinder.addSubview(toggleCameraButton)
        
        //Setup Camera Capture View
        cameraCaptureView = CameraCaptureView(frame: .zero)
        cameraCaptureView.photoCaptureButton.addTarget(self, action: #selector(photoCaptureButtonPressed), for: .touchUpInside)
        cameraCaptureView.videoCaptureButton.addTarget(self, action: #selector(photoCaptureButtonPressed), for: .touchUpInside)
        cameraCaptureView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cameraCaptureView)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let viewDict = ["cameraViewFinder": cameraViewFinder,"toggleFlashButton": toggleFlashButton, "toggleCameraButton": toggleCameraButton, "cameraCaptureView": cameraCaptureView] as [String : Any]
        //Width & Horizontal Alignment
        self.cameraViewFinder.addConstraint(NSLayoutConstraint.init(item: toggleCameraButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        self.cameraViewFinder.addConstraint(NSLayoutConstraint.init(item: toggleCameraButton, attribute: .leading, relatedBy: .equal, toItem: self.cameraViewFinder, attribute: .leading, multiplier: 1, constant: 0))
        self.cameraViewFinder.addConstraint(NSLayoutConstraint.init(item: toggleFlashButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        self.cameraViewFinder.addConstraint(NSLayoutConstraint.init(item: toggleFlashButton, attribute: .trailing, relatedBy: .equal, toItem: self.cameraViewFinder, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cameraViewFinder]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cameraCaptureView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraint(NSLayoutConstraint.init(item: cameraViewFinder, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.65, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: cameraCaptureView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.35, constant: 0))
        self.cameraViewFinder.addConstraint(NSLayoutConstraint.init(item: toggleCameraButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        self.cameraViewFinder.addConstraint(NSLayoutConstraint.init(item: toggleCameraButton, attribute: .bottom, relatedBy: .equal, toItem: self.cameraViewFinder, attribute: .bottom, multiplier: 1, constant: 0))
        self.cameraViewFinder.addConstraint(NSLayoutConstraint.init(item: toggleFlashButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        self.cameraViewFinder.addConstraint(NSLayoutConstraint.init(item: toggleFlashButton, attribute: .bottom, relatedBy: .equal, toItem: self.cameraViewFinder, attribute: .bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: cameraCaptureView, attribute: .top, relatedBy: .equal, toItem: cameraViewFinder, attribute: .bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: cameraCaptureView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    // Button Delegates
    func toggleFlashButtonPressed(sender: UIButton){
        delegate.toggleFlashButtonPressed(sender: sender)
    }
    
    func toggleCameraButtonPressed(sender: UIButton){
        delegate.toggleCameraButtonPressed(sender: sender)
    }
    
    func photoCaptureButtonPressed(){
        delegate.didPressPhotoCaptureButton()
    }
    
    func videoCaptureButtonPressed(){
        delegate.didPressVideoCaptureButton()
    }
}
