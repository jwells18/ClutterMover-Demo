//
//  CLCircularButton.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class CLCircularButton: UIButton{
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        //Setup Button
        backgroundColor = CLColor.primary
        tintColor = .white
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .top
        
        //Add Shadow
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = (self.frame.width+4)/2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Set Frames
        layer.cornerRadius = frame.width/2
        contentEdgeInsets = UIEdgeInsetsMake(frame.width/4, frame.width/4, frame.width/4, frame.width/4)
    }
}
