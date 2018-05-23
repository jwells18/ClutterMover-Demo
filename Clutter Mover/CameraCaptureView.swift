//
//  CameraCaptureView.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class CameraCaptureView: UIScrollView{
    
    var photoContainerView: UIView!
    var photoCaptureButton: UIButton!
    var videoContainerView: UIView!
    var videoCaptureButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = .white
        self.bounces = false
        self.isPagingEnabled = true
        self.contentInset = .zero
        self.showsHorizontalScrollIndicator = false
        
        //Setup Photo Container View
        photoContainerView = UIView(frame: .zero)
        photoContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(photoContainerView)
        
        //Setup Photo Capture Button
        self.setupPhotoCaptureButton()
        
        //Setup Video Container View
        videoContainerView = UIView(frame: .zero)
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(videoContainerView)
        
        //Setup Video Capture Button
        self.setupVideoCaptureButton()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupPhotoCaptureButton(){
        photoCaptureButton = UIButton(frame: .zero)
        photoCaptureButton.layer.borderColor = UIColor.lightGray.cgColor
        photoCaptureButton.layer.borderWidth = 8
        photoCaptureButton.layer.cornerRadius = 80/2
        photoCaptureButton.translatesAutoresizingMaskIntoConstraints = false
        self.photoContainerView.addSubview(photoCaptureButton)
    }
    
    func setupVideoCaptureButton(){
        videoCaptureButton = UIButton(frame: .zero)
        videoCaptureButton.layer.borderColor = UIColor.lightGray.cgColor
        videoCaptureButton.layer.borderWidth = 8
        videoCaptureButton.layer.cornerRadius = 80/2
        videoCaptureButton.translatesAutoresizingMaskIntoConstraints = false
        self.videoContainerView.addSubview(videoCaptureButton)
    }
    
    func setupConstraints(){
        let viewDict = ["photoContainerView": photoContainerView, "photoCaptureButton": photoCaptureButton, "videoContainerView": videoContainerView, "videoCaptureButton": videoCaptureButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[photoContainerView][videoContainerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints([NSLayoutConstraint.init(item: photoContainerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: videoContainerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)])
        self.photoContainerView.addConstraints([NSLayoutConstraint.init(item: photoCaptureButton, attribute: .centerX, relatedBy: .equal, toItem: self.photoContainerView, attribute: .centerX, multiplier: 1, constant: 0)])
        self.photoContainerView.addConstraints([NSLayoutConstraint.init(item: photoCaptureButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)])
        self.videoContainerView.addConstraints([NSLayoutConstraint.init(item: videoCaptureButton, attribute: .centerX, relatedBy: .equal, toItem: self.videoContainerView, attribute: .centerX, multiplier: 1, constant: 0)])
        self.videoContainerView.addConstraints([NSLayoutConstraint.init(item: videoCaptureButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)])
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[photoContainerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[videoContainerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints([NSLayoutConstraint.init(item: photoContainerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: videoContainerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)])
        self.photoContainerView.addConstraints([NSLayoutConstraint.init(item: photoCaptureButton, attribute: .centerY, relatedBy: .equal, toItem: self.photoContainerView, attribute: .centerY, multiplier: 1, constant: 0)])
        self.photoContainerView.addConstraints([NSLayoutConstraint.init(item: photoCaptureButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)])
        self.videoContainerView.addConstraints([NSLayoutConstraint.init(item: videoCaptureButton, attribute: .centerY, relatedBy: .equal, toItem: self.videoContainerView, attribute: .centerY, multiplier: 1, constant: 0)])
        self.videoContainerView.addConstraints([NSLayoutConstraint.init(item: videoCaptureButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)])
    }
}
