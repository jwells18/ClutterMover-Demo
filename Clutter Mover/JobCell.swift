//
//  JobCell.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import CoreLocation

protocol JobCellDelegate {
    func didPressMapButton(sender:UIButton)
}

class JobCell: UITableViewCell{
    
    var jobCellDelegate: JobCellDelegate!
    var timeLabel = UILabel()
    var separatorLine = UIView()
    var titleLabel = UILabel()
    var addressLabel = UILabel()
    var planSizeLabel = UILabel()
    var mapButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.selectionStyle = .none
        
        //Setup Date Label
        timeLabel.textColor = .darkGray
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timeLabel)
        
        //SeparatorLine
        separatorLine.backgroundColor = CLColor.faintGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separatorLine)
        
        //Setup Title Label
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        //Setup Address Label
        addressLabel.textColor = .darkGray
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addressLabel)
        
        //Setup Plan Size Label
        planSizeLabel.textColor = CLColor.primary
        planSizeLabel.font = UIFont.systemFont(ofSize: 14)
        planSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(planSizeLabel)
        
        //Setup Map ImageView
        mapButton.backgroundColor = CLColor.faintGray
        mapButton.layer.cornerRadius = 5
        mapButton.clipsToBounds = true
        mapButton.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mapButton)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        //Add SpacerViews
        let spacerViewTop = UIView()
        spacerViewTop.isUserInteractionEnabled = false
        spacerViewTop.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerViewTop)
        let spacerViewBottom = UIView()
        spacerViewBottom.isUserInteractionEnabled = false
        spacerViewBottom.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerViewBottom)
        
        let viewDict = ["timeLabel": timeLabel,"separatorLine": separatorLine, "titleLabel": titleLabel, "addressLabel": addressLabel, "planSizeLabel": planSizeLabel, "mapButton": mapButton, "spacerViewTop": spacerViewTop, "spacerViewBottom": spacerViewBottom] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[timeLabel(85)]-4-[separatorLine(1)]-8-[titleLabel]-[mapButton(60)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: addressLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: addressLabel, attribute: .width, relatedBy: .equal, toItem: titleLabel, attribute: .width, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: planSizeLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: planSizeLabel, attribute: .width, relatedBy: .equal, toItem: titleLabel, attribute: .width, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewTop, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewTop, attribute: .width, relatedBy: .equal, toItem: titleLabel, attribute: .width, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewBottom, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewBottom, attribute: .width, relatedBy: .equal, toItem: titleLabel, attribute: .width, multiplier: 1, constant: 0))
        //Height & Vertical Alignment
        self.addConstraint(NSLayoutConstraint.init(item: timeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[spacerViewTop(>=8)][titleLabel]-2-[addressLabel]-2-[planSizeLabel][spacerViewBottom(>=8)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[separatorLine]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewTop, attribute: .height, relatedBy: .equal, toItem: spacerViewBottom, attribute: .height, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewBottom, attribute: .height, relatedBy: .equal, toItem: spacerViewTop, attribute: .height, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: mapButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: mapButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60))
    }
    
    func configure(job: DBJob){
        timeLabel.text = job.startDate.dateValue().timeLong()?.uppercased()
        
        titleLabel.text = job.customerName
        addressLabel.text = String(format: "%@ %@", job.subThoroughfare, job.thoroughfare)
        planSizeLabel.text = String(format: "%@ / %@", job.type.localized(), job.planType.localized())
        let mapManager = MapManager()
        let jobLocation = CLLocation(latitude: job.latitude, longitude: job.longitude)
        let mapFrame = CGRect(x: 0, y: 0, width: 60, height: 60)
        mapManager.createMapImageforLocation(location: jobLocation, frame: mapFrame, completionHandler: { (image) in
            self.mapButton.setImage(image, for: .normal)
        })
    }
    
    //Button Delegates
    func mapButtonPressed(sender:UIButton){
        jobCellDelegate.didPressMapButton(sender: sender)
    }
}
