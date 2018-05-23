//
//  CLSettingsCell.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/12/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class CLSettingsCell: UITableViewCell{
    
    var iconImageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var accessoryImageView = UIImageView()
    
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
        
        //Setup Icon ImageView
        self.setupIconImageView()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup SubTitle Label
        self.setupSubTitleLabel()
        
        //Setup Accessory ImageView
        self.setupAccessoryImageView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupIconImageView(){
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 5
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconImageView)
    }
    
    func setupTitleLabel(){
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupSubTitleLabel(){
        subTitleLabel.textColor = .lightGray
        subTitleLabel.textAlignment = .right
        subTitleLabel.font = UIFont.systemFont(ofSize: 16)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subTitleLabel)
    }
    
    func setupAccessoryImageView(){
        accessoryImageView.image = UIImage(named: "forward")!.withRenderingMode(.alwaysTemplate)
        accessoryImageView.tintColor = CLColor.faintGray
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(accessoryImageView)
    }
    
    func configure(image: UIImage?, title: String, subTitle: String?, hideAccessoryView: Bool){
        self.iconImageView.image = image
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        self.accessoryImageView.isHidden = hideAccessoryView
    }
    
    func setupConstraints(){
        let spacerView = UIView()
        spacerView.isUserInteractionEnabled = false
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerView)
        
        let viewDict = ["iconImageView": iconImageView, "titleLabel": titleLabel, "subTitleLabel": subTitleLabel, "accessoryImageView": accessoryImageView, "spacerView": spacerView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[iconImageView(30)]-[titleLabel][spacerView][subTitleLabel]-[accessoryImageView(25)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraint(NSLayoutConstraint.init(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: iconImageView, attribute: .height, relatedBy: .equal, toItem:  nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
        self.addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .height, relatedBy: .equal, toItem:  nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
        self.addConstraint(NSLayoutConstraint.init(item: subTitleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: subTitleLabel, attribute: .height, relatedBy: .equal, toItem:  nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
        self.addConstraint(NSLayoutConstraint.init(item: accessoryImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: accessoryImageView, attribute: .height, relatedBy: .equal, toItem:  nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
        self.addConstraint(NSLayoutConstraint.init(item: spacerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerView, attribute: .height, relatedBy: .equal, toItem:  nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
    }
}

