//
//  LaunchController.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/22/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class LaunchController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //Setup NavigationBar
        self.setupNavigationHeader()
    }
    
    func setupNavigationHeader(){
        //Setup Separator Line
        let separatorLine = UIView(frame: CGRect(x: 0, y: 119.5, width: w, height: 0.5))
        separatorLine.backgroundColor = .lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(separatorLine)
    }
}
    
