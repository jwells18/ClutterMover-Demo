//
//  CreateItemHeader.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import SDWebImage

class CreateItemHeader: UIView{
    
    var itemImageView = UIImageView()
    var itemDescriptionTextView = KMPlaceholderTextView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = .white
        
        //Setup Item ImageView
        itemImageView.layer.cornerRadius = 5
        itemImageView.clipsToBounds = true
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(itemImageView)
        
        //Setup Item Description TextView
        itemDescriptionTextView.placeholder = "addADescription".localized()
        itemDescriptionTextView.font = UIFont.systemFont(ofSize: 18)
        itemDescriptionTextView.textColor = .darkGray
        itemDescriptionTextView.tintColor = CLColor.primary
        itemDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(itemDescriptionTextView)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let viewDict = ["itemImageView": itemImageView, "itemDescriptionTextView": itemDescriptionTextView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[itemImageView(75)]-[itemDescriptionTextView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[itemImageView(75)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[itemDescriptionTextView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(image: UIImage?, dbItem: DBInventoryItem?){
        //Setup Item ImageView
        if(image != nil){
            itemImageView.image = image
        }
        else if(dbItem?.image != nil){
            itemImageView.sd_setImage(with: URL(string: (dbItem?.image)!), completed: nil)
        }
        else{
            itemImageView.image = nil
        }
    }
}
