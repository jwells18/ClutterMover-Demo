//
//  JobMapSectionCell.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import MapKit

protocol JobMapSectionCellDelegate {
    func didPressDirectionsButton(sender: UIButton)
}

class JobMapSectionCell: UICollectionViewCell{
    
    var jobMapSectionCellDelegate: JobMapSectionCellDelegate!
    var scrollView = UIScrollView()
    var mapView = MKMapView()
    var containerView = UIView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var directionsButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        self.backgroundColor = .white
        
        //Setup ScrollView
        scrollView.alwaysBounceVertical = true
        scrollView.contentSize = self.frame.size
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        //Setup MapView
        self.setupMapView()
        
        //Setup ContainerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(containerView)
        
        //Setup Title Label
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(titleLabel)
        
        //Setup SubTitle Label
        subTitleLabel.textColor = .darkGray
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont.systemFont(ofSize: 16)
        subTitleLabel.numberOfLines = 0
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(subTitleLabel)
        
        //Setup Directions Button
        directionsButton.backgroundColor = CLColor.primary
        directionsButton.layer.cornerRadius = 5
        directionsButton.addTarget(self, action: #selector(directionsButtonPressed), for: .touchUpInside)
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(directionsButton)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupMapView(){
        //Setup MapView
        mapView.layer.cornerRadius = 5
        mapView.clipsToBounds = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(mapView)
    }
    
    func setupConstraints(){
        let viewDict = ["scrollView": scrollView, "mapView": mapView, "containerView": containerView, "titleLabel": titleLabel, "subTitleLabel": subTitleLabel, "directionsButton": directionsButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.scrollView.addConstraints([NSLayoutConstraint.init(item: mapView, attribute: .width, relatedBy: .equal, toItem: self.scrollView, attribute: .width, multiplier: 0.9, constant: 0)])
        self.scrollView.addConstraints([NSLayoutConstraint.init(item: mapView, attribute: .centerX, relatedBy: .equal, toItem: self.scrollView, attribute: .centerX, multiplier: 1, constant: 0)])
        self.scrollView.addConstraints([NSLayoutConstraint.init(item: containerView, attribute: .width, relatedBy: .equal, toItem: self.scrollView, attribute: .width, multiplier: 0.9, constant: 0)])
        self.scrollView.addConstraints([NSLayoutConstraint.init(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: self.scrollView, attribute: .centerX, multiplier: 1, constant: 0)])
        self.containerView.addConstraints([NSLayoutConstraint.init(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self.containerView, attribute: .width, multiplier: 1, constant: 0)])
        self.containerView.addConstraints([NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.containerView, attribute: .centerX, multiplier: 1, constant: 0)])
        self.containerView.addConstraints([NSLayoutConstraint.init(item: subTitleLabel, attribute: .width, relatedBy: .equal, toItem: self.containerView, attribute: .width, multiplier: 1, constant: 0)])
        self.containerView.addConstraints([NSLayoutConstraint.init(item: subTitleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.containerView, attribute: .centerX, multiplier: 1, constant: 0)])
        self.containerView.addConstraints([NSLayoutConstraint.init(item: directionsButton, attribute: .width, relatedBy: .equal, toItem: self.containerView, attribute: .width, multiplier: 0.6, constant: 0)])
        self.containerView.addConstraints([NSLayoutConstraint.init(item: directionsButton, attribute: .centerX, relatedBy: .equal, toItem: self.containerView, attribute: .centerX, multiplier: 1, constant: 0)])
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[mapView]-16-[containerView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.scrollView.addConstraints([NSLayoutConstraint.init(item: mapView, attribute: .height, relatedBy: .equal, toItem: mapView, attribute: .width, multiplier: 0.75, constant: 0)])
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel]-2-[subTitleLabel]-16-[directionsButton(40)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(job: DBJob){
        titleLabel.text = job.customerName
        subTitleLabel.text = String(format: "%@ %@\n%@, %@", job.subThoroughfare, job.thoroughfare, job.locality, job.administrativeArea)
        directionsButton.setTitle("getDirections".localized(), for: .normal)

        //Setup MapView
        let location = CLLocation(latitude: job.latitude, longitude: job.longitude)
        var region = MKCoordinateRegion()
        region.center.latitude = location.coordinate.latitude;
        region.center.longitude = location.coordinate.longitude;
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        self.mapView.addAnnotation(annotation)
    }
    
    //Button Delegate
    func directionsButtonPressed(sender: UIButton){
        jobMapSectionCellDelegate.didPressDirectionsButton(sender: sender)
    }
}

