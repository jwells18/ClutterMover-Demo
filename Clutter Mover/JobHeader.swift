//
//  JobHeader.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import HMSegmentedControl

class JobHeader: UIView{
    
    var segmentedControl: HMSegmentedControl!
    var separatorLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        //Setup SegmentedControl
        self.setupSegmentedControl()
        
        //Setup Separator Line
        self.setupSeparatorLine()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupSegmentedControl(){
        segmentedControl = HMSegmentedControl(sectionTitles: jobHeaderTitles)
        segmentedControl.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        segmentedControl.tintColor = .lightGray
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectionIndicatorColor = CLColor.primary
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.selectionIndicatorHeight = 2
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.lightGray]
        segmentedControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: CLColor.primary]
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(segmentedControl)
    }
    
    func setupSeparatorLine(){
        separatorLine.backgroundColor = .lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separatorLine)
    }
    
    func setupConstraints(){
        let viewDict = ["segmentedControl": segmentedControl, "separatorLine": separatorLine] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentedControl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separatorLine]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[segmentedControl][separatorLine(0.5)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}
