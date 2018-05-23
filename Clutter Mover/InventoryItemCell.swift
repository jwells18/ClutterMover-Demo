//
//  InventoryItemCell.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol InventoryItemCellDelegate {
    func didPressSelectButton(sender: UIButton)
}

class InventoryItemCell: UICollectionViewCell{
    
    var inventoryItemCellDelegate: InventoryItemCellDelegate!
    var imageView = UIImageView()
    var labelContainerView = UIView()
    var objectIdLabel = UILabel()
    var categoryLabel = UILabel()
    var nameLabel = UILabel()
    var selectButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderColor = CLColor.faintGray.cgColor
        self.layer.borderWidth = 1
        
        //Setup ImageView
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        //Setup ContainerView
        labelContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelContainerView)
        
        //Setup ObjectId Label
        objectIdLabel.textColor = .lightGray
        objectIdLabel.font = UIFont.systemFont(ofSize: 12)
        objectIdLabel.translatesAutoresizingMaskIntoConstraints = false
        self.labelContainerView.addSubview(objectIdLabel)
        
        //Setup Title Label
        categoryLabel.textColor = .darkGray
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 14)
        categoryLabel.numberOfLines = 2
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.labelContainerView.addSubview(categoryLabel)
        
        //Setup description Label
        nameLabel.textColor = .darkGray
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.labelContainerView.addSubview(nameLabel)
        
        //Setup Select Button
        selectButton.setImage(UIImage(named: "checkmark"), for: .normal)
        selectButton.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.6)
        selectButton.layer.borderColor = UIColor.white.cgColor
        selectButton.layer.borderWidth = 1
        selectButton.clipsToBounds = true
        selectButton.layer.cornerRadius = 5
        selectButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        selectButton.addTarget(self, action: #selector(self.selectButtonPressed), for: .touchUpInside)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(selectButton)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let viewDict = ["imageView": imageView, "labelContainerView": labelContainerView, "objectIdLabel": objectIdLabel, "categoryLabel": categoryLabel, "nameLabel": nameLabel, "selectButton": selectButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[imageView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[labelContainerView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.labelContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[objectIdLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.labelContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[categoryLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.labelContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[nameLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[selectButton(25)]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[imageView]-[labelContainerView(56)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.labelContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[objectIdLabel]-2-[categoryLabel]-2-[nameLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[selectButton(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(item: InventoryItem?, selectedItems: Set<InventoryItem>){
        //Set ImageView Image
        if (item?.image != nil){
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setIndicatorStyle(.gray)
            imageView.sd_setImage(with: URL(string: (item?.image!)!), placeholderImage: nil)
        }
        else{
            imageView.image = UIImage(named: "box")
        }
        objectIdLabel.text = String(format: "#%@", item?.objectId ?? "")
        categoryLabel.text = item?.category ?? ""
        nameLabel.text = item?.caption ?? ""
        //Set Select Button
        switch selectedItems.contains(item!){
        case true:
            selectButton.backgroundColor = UIColor(red: 30/255, green: 171/255, blue: 161/255, alpha: 0.6)
        case false:
            selectButton.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.6)
        }
    }
    
    //Button Delegate
    func selectButtonPressed(sender: UIButton){
        inventoryItemCellDelegate.didPressSelectButton(sender: sender)
    }
}
