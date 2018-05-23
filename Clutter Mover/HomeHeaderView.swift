//
//  HomeNavigationView.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import SDWebImage

class HomeHeaderView: UIView{
    
    var titleContainerView = UIView()
    var titleButton = UIButton()
    var dateButton = UIButton()
    var profileButton = UIButton()
    var separatorLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        //Setup ContainerView
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleContainerView)
        
        //Setup Title Label
        titleButton.setTitle("jobs".localized(), for: .normal)
        titleButton.setTitleColor(.darkGray, for: .normal)
        titleButton.titleLabel?.font = .boldSystemFont(ofSize: 36)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        titleButton.contentHorizontalAlignment = .left
        self.titleContainerView.addSubview(titleButton)
        
        //Setup Date Label
        dateButton.setTitle("today".localized(), for: .normal)
        dateButton.setTitleColor(.lightGray, for: .normal)
        dateButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.contentHorizontalAlignment = .left
        self.titleContainerView.addSubview(dateButton)
        
        //Setup Profile Button
        profileButton.setImage(UIImage(named: "profilePicturePlaceholder"), for: .normal)
        profileButton.backgroundColor = CLColor.faintGray
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = CLColor.primary.cgColor
        profileButton.clipsToBounds = true
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileButton)
        
        //Setup Separator Line
        separatorLine.backgroundColor = .lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separatorLine)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func configure(employee: DBEmployee?, date: Date?){
        if(employee?.image != nil){
            profileButton.sd_setImage(with: URL(string: (employee?.image)!), for: .normal, completed: nil)
        }
        else{
            profileButton.setImage(UIImage(named: "profilePicturePlaceholder"), for: .normal)
        }
    }
    
    func setupConstraints(){
        //Add SpacerViews
        let spacerViewTop = UIView()
        spacerViewTop.isUserInteractionEnabled = false
        spacerViewTop.translatesAutoresizingMaskIntoConstraints = false
        self.titleContainerView.addSubview(spacerViewTop)
        let spacerViewBottom = UIView()
        spacerViewBottom.isUserInteractionEnabled = false
        spacerViewBottom.translatesAutoresizingMaskIntoConstraints = false
        self.titleContainerView.addSubview(spacerViewBottom)
        
        let viewDict = ["titleContainerView": titleContainerView, "titleButton": titleButton, "dateButton": dateButton, "profileButton": profileButton, "separatorLine": separatorLine, "spacerViewTop": spacerViewTop, "spacerViewBottom": spacerViewBottom] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleContainerView]-[profileButton(40)]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separatorLine]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.titleContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.titleContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dateButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.titleContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[spacerViewTop]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.titleContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[spacerViewBottom]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraint(NSLayoutConstraint.init(item: titleContainerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: profileButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: profileButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        self.titleContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[spacerViewTop(==spacerViewBottom)][titleButton(40)]-2-[dateButton(20)][spacerViewBottom(==spacerViewTop)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[separatorLine(0.5)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func layoutSubviews() {
        profileButton.layer.cornerRadius = 40/2
    }
}

