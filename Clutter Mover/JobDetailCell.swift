//
//  JobDetailCell.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class JobDetailCell: UITableViewCell{
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        //Setup Name Label
        self.titleLabel.textColor = .darkGray
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        
        //Setup Name Label
        self.subTitleLabel.textColor = .darkGray
        self.subTitleLabel.font = UIFont.systemFont(ofSize: 16)
        self.subTitleLabel.numberOfLines = 0
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.subTitleLabel)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let viewDict = ["titleLabel": titleLabel, "subTitleLabel": subTitleLabel] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel(100)]-[subTitleLabel]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[subTitleLabel(>=20)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(key: String, job: DBJob){
        titleLabel.text = key.localized()
        switch key{
        case _ where key == "customerName":
            subTitleLabel.text = job.customerName
            break
        case _ where key == "address":
            subTitleLabel.text = String(format: "%@ %@\n%@, %@", job.subThoroughfare, job.thoroughfare, job.locality, job.administrativeArea)
            break
        case _ where key == "type":
            subTitleLabel.text = job.type.localized()
            break
        case _ where key == "plan":
            subTitleLabel.text = job.planType.localized()
            break
        case _ where key == "startDate":
            subTitleLabel.text = job.startDate.dateValue().timeLong()?.uppercased()
            break
        case _ where key == "phone":
            subTitleLabel.text = job.customerPhone
            break
        case _ where key == "notes":
            subTitleLabel.text = job.notes
            break
        default:
            break
        }
    }
}
