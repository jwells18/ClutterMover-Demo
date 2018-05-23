//
//  CLSectionHeader.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/12/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class CLSectionHeader: UIView{
    
    var titleLabel =  UILabel()
    private var separatorLine = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        //Setup Title Label
        titleLabel.text = "tags".localized()
        titleLabel.textColor = .lightGray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        //Setup Separator Line
        separatorLine.backgroundColor = CLColor.faintGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separatorLine)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let viewDict = ["titleLabel": titleLabel, "separatorLine": separatorLine]
        //Set Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLabel]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separatorLine]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Set Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel][separatorLine(1)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}
