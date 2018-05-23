//
//  CLPhotoLibraryCell.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//


import UIKit

class CLPhotoLibraryCell :UICollectionViewCell{
    
    var imageView = UIImageView()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CLColor.faintGray
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
    }
}
