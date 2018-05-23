//
//  CameraLibraryView.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Photos

protocol CameraLibraryViewDelegate {
    func relayDidChooseLibraryPhoto(image: UIImage)
}

class CameraLibraryView: UIView, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var cameraLibraryViewDelegate: CameraLibraryViewDelegate!
    private var cellIdentifier = "cell"
    private var allPhotos: PHFetchResult<PHAsset>!
    fileprivate var imageManager = PHCachingImageManager()
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:(w-60)/3, height:(w-60)/3)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 10, right: 15)
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
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
        
        //Download Photos
        self.downloadPhotos()
        
        //Setup CollectionView
        self.setupCollectionView()
        
        //Setuup Constraints
        self.setupConstraints()
    }
    
    func downloadPhotos(){
        //Download All Photos
        if (allPhotos == nil){
            //Fetch for new Photos
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.sortDescriptors = [
                        NSSortDescriptor(key: "creationDate", ascending: false)
                    ]
                    self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                    DispatchQueue.main.async{
                        if((self.allPhotos?.count)! > 0){
                            self.collectionView.reloadData()
                        }
                    }
                case .denied, .restricted:
                    break
                case .notDetermined:
                    break
                }
            }
        }
    }
    
    func setupCollectionView(){
        //Register Cell for CollectionView
        collectionView.register(CLPhotoLibraryCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
    
    func setupConstraints(){
        let viewDict = ["collectionView": collectionView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //CollectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (allPhotos?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CLPhotoLibraryCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CLPhotoLibraryCell
        
        let currentTag = cell.tag + 1
        cell.tag = currentTag
        let asset = self.allPhotos[(indexPath as NSIndexPath).item]
        self.imageManager.requestImage(for: asset,
                                       targetSize: CGSize(width:100, height:100),
                                       contentMode: .aspectFill,
                                       options: nil) {
                                        result, info in
                                        if cell.tag == currentTag {
                                            cell.image = result
                                        }
        }
        
        return cell
    }
    
    //CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let asset = self.allPhotos[(indexPath as NSIndexPath).item]
        
        let options = PHImageRequestOptions()
        options.resizeMode = PHImageRequestOptionsResizeMode.exact
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
        self.imageManager.requestImage(for: asset,
                                       targetSize: PHImageManagerMaximumSize,
                                       contentMode: .aspectFill,
                                       options: options) {
                                        image, info in
                                        
                                        self.cameraLibraryViewDelegate.relayDidChooseLibraryPhoto(image: image!)
                                        
        }
    }
}


