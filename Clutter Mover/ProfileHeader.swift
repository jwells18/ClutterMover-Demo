//
//  ProfileHeader.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/12/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileHeader: UIView{
    
    var profileImageView = UIImageView()
    var titleLabel = UILabel()
    
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
        
        //Setup Profile ImageView
        self.setupProfileImageView()
        
        //Setup Title Label
        self.setupTitleLabel()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupProfileImageView(){
        profileImageView.image = UIImage(named: "profilePicturePlaceholder")
        profileImageView.backgroundColor = CLColor.faintGray
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = CLColor.primary.cgColor
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileImageView)
    }
    
    func setupTitleLabel(){
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func configure(employee: DBEmployee?){
        if(employee?.image != nil){
            profileImageView.sd_setImage(with: URL(string: (employee?.image)!), completed: nil)
        }
        else{
            profileImageView.image = UIImage(named: "profilePicturePlaceholder")
        }
        titleLabel.text = String(format: "%@ %@", employee?.firstName ?? "", employee?.lastName ?? "")
    }
    
    func setupConstraints(){
        let viewDict = ["profileImageView": profileImageView, "titleLabel": titleLabel] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints([NSLayoutConstraint.init(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        self.addConstraint(NSLayoutConstraint.init(item: profileImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80))
        self.addConstraints([NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: profileImageView, attribute: .centerX, multiplier: 1, constant: 0)])
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[profileImageView(80)]-12-[titleLabel(24)]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}
