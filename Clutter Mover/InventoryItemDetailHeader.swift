//
//  InventoryItemDetailHeader.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/18/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import SDWebImage

class InventoryItemDetailHeader: UIView{
    
    var imageView = UIImageView()
    
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
        
        //Setup Account ImageView
        self.setupImageView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupImageView(){
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
    }
    
    func configure(item: InventoryItem?){
        if(item?.image != nil){
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setIndicatorStyle(.gray)
            imageView.sd_setImage(with: URL(string: (item?.image)!), completed: nil)
        }
        else{
            imageView.image = UIImage(named: "box")
        }
    }
    
    func setupConstraints(){
        //Width & Horizontal Alignment
        self.addConstraints([NSLayoutConstraint.init(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.9, constant: 0)])
        //Height & Vertical Alignment
        self.addConstraints([NSLayoutConstraint.init(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint.init(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.9, constant: 0)])
    }
}
