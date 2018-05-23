//
//  JobInventorySectionCell.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol JobInventorySectionCellDelegate{
    func didPressInventoryCell(indexPath: IndexPath)
    func didPressSelectButton(indexPath: IndexPath?)
}

class JobInventorySectionCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, InventoryItemCellDelegate{
    
    var jobInventorySectionCellDelegate: JobInventorySectionCellDelegate!
    private var downloadingActivityView = UIActivityIndicatorView()
    private var inventoryItems = [InventoryItem]()
    private var itemsSelectedSet = Set<InventoryItem>()
    private let myInventoryItemCellIdentifier = "myInventoryItemCellIdentifier"
    private let myInventoryToolbarCellIdentifier = "myInventoryToolbarCellIdentifier"
    private var emptyCollectionViewLabel = UILabel()
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 10)
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        self.backgroundColor = CLColor.faintGray
        
        //Setup CollectionView
        self.setupCollectionView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupCollectionView(){
        //Register Cell for CollectionView
        collectionView.register(InventoryItemCell.self, forCellWithReuseIdentifier: myInventoryItemCellIdentifier)
        self.addSubview(collectionView)
        
        //Setup Downloading ActivityView
        downloadingActivityView.activityIndicatorViewStyle = .gray
        collectionView.backgroundView = downloadingActivityView
        
        //Setup EmptyCollectionView
        emptyCollectionViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: 250))
        emptyCollectionViewLabel.text = "emptyItems".localized()
        emptyCollectionViewLabel.textColor = .lightGray
        emptyCollectionViewLabel.textAlignment = .center
        emptyCollectionViewLabel.font  = UIFont.boldSystemFont(ofSize: 22)
        emptyCollectionViewLabel.numberOfLines = 0
    }
    
    func setupConstraints(){
        let viewDict = ["collectionView": collectionView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    func configure(items: [InventoryItem], selectedItems: Set<InventoryItem>){
        self.inventoryItems = items
        self.itemsSelectedSet = selectedItems
        
        //Show Empty View (if necessary)
        if self.inventoryItems.count > 0{
            self.collectionView.backgroundView = nil
        }
        else{
            self.collectionView.backgroundView = self.emptyCollectionViewLabel
        }
        
        self.collectionView.reloadData()
    }
    
    //CollectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inventoryItems.count
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (collectionView.frame.width-30)/2, height: (collectionView.frame.width-30)/2+64)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myInventoryItemCellIdentifier, for: indexPath) as! InventoryItemCell
        cell.configure(item: inventoryItems[indexPath.row], selectedItems: itemsSelectedSet)
        cell.inventoryItemCellDelegate = self
        return cell
    }
    
    //CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        jobInventorySectionCellDelegate.didPressInventoryCell(indexPath: indexPath)
    }
    
    //Button Delegates
    func didPressSelectButton(sender: UIButton) {
        let touchPoint = sender.convert(CGPoint.zero, to: collectionView)
        let indexPath = collectionView.indexPathForItem(at: touchPoint)
        jobInventorySectionCellDelegate.didPressSelectButton(indexPath: indexPath)
    }
}
