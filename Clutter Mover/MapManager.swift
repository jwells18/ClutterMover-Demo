//
//  MapManager.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import MapKit

class MapManager: NSObject{
    
    func createMapImageforLocation(location: CLLocation, frame: CGRect, completionHandler:@escaping (UIImage) -> Void){
        //Setup MapView
        let mapView = MKMapView(frame: frame)
        
        var region = MKCoordinateRegion()
        region.center.latitude = location.coordinate.latitude;
        region.center.longitude = location.coordinate.longitude;
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
        
        let options = MKMapSnapshotOptions()
        options.region = mapView.region
        options.size = mapView.frame.size
        options.scale = UIScreen.main.scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if(snapshot != nil){
                completionHandler((snapshot?.image)!)
            }
            else{
                completionHandler(UIImage())
            }
        }
    }
    
}
