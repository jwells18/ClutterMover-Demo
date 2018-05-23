//
//  CLTitleView.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class CLTitleView: UIView{
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        //Setup Title Label
        titleLabel.textColor = CLColor.primary
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        //Setup SubTitleLabel
        subTitleLabel.textColor = .lightGray
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subTitleLabel)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let viewDict = ["titleLabel": titleLabel, "subTitleLabel": subTitleLabel] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subTitleLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel][subTitleLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(job: DBJob){
        titleLabel.text = String(format: "%@ %@", job.subThoroughfare, job.thoroughfare)
        subTitleLabel.text = job.type.localized()
    }
}

