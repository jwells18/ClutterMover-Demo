//
//  ToastManagerExtension.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Toast_Swift

extension ToastManager{
    
    func startListening(){
        //Add Observer for All Toast Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.showToast(_:)), name: NSNotification.Name(rawValue: presentToastNotification), object: nil)
    }
    
    func stopListening(){
        //Remove Observer for All Toast Notifications
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: presentToastNotification), object: nil)
    }
    
    //Toast Methods
    @objc func showToast(_ notification: NSNotification) {
        let message = notification.userInfo?["message"] as? String
        let image = notification.userInfo?["image"] as? String
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootVC = appDelegate.window!.rootViewController
        
        if (message != nil && image != nil){
            let toastView = self.createDefaultImageToast(string: message!, image: image!)
            ToastManager.shared.isTapToDismissEnabled = true
            rootVC?.view.showToast(toastView, duration: 4.0, point: CGPoint(x: w/2, y: h-(toastView.frame.height/2)-64), completion: nil)
        }
        else if (message != nil){
            let toastView = self.createDefaultToast(string: message!)
            ToastManager.shared.isTapToDismissEnabled = true
            rootVC?.view.showToast(toastView, duration: 4.0, point: CGPoint(x: w/2, y: h-(toastView.frame.height/2)-64), completion: nil)
        }
        
        //Post Notification to refresh Profile Controller
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: refreshProfileVCNotification), object: nil, userInfo: nil)
    }
    
    //Toast Creation
    func createDefaultToast(string: String) -> UIView{
        //Setup Toast View
        let toastView = UIView(frame: CGRect(x: 0, y: 0, width: w-30, height: 60))
        toastView.backgroundColor = .darkGray
        toastView.layer.shadowColor = UIColor.white.cgColor
        toastView.layer.cornerRadius = toastView.frame.height/2
        toastView.clipsToBounds = true
        //Setup Toast Message Label
        let toastMessageLabel = UILabel(frame: CGRect(x: 25, y: 10, width: w-40, height: 40))
        toastMessageLabel.text = string
        toastMessageLabel.textColor = .white
        toastMessageLabel.font = UIFont.boldSystemFont(ofSize: 20)
        toastMessageLabel.numberOfLines = 0
        toastView.addSubview(toastMessageLabel)
        
        return toastView
    }
    
    func createDefaultImageToast(string: String, image: String) -> UIView{
        //Setup Toast View
        let toastView = UIView(frame: CGRect(x: 0, y: 0, width: w-30, height: 80))
        toastView.backgroundColor = .darkGray
        toastView.layer.shadowColor = UIColor.white.cgColor
        toastView.layer.cornerRadius = toastView.frame.height/2
        toastView.clipsToBounds = true
        //Setup Toast ImageView
        let toastImageView = UIImageView(frame: CGRect(x: 25, y: 10, width: 60, height: 60))
        toastImageView.sd_setImage(with: URL(string:image), completed: nil)
        toastImageView.layer.cornerRadius = 5
        toastImageView.clipsToBounds = true
        toastView.addSubview(toastImageView)
        //Setup Toast Message Label
        let toastMessageLabel = UILabel(frame: CGRect(x: 25+60+15, y: 10, width: w-40-60-15, height: 60))
        toastMessageLabel.text = string
        toastMessageLabel.textColor = .white
        toastMessageLabel.font = UIFont.boldSystemFont(ofSize: 20)
        toastMessageLabel.numberOfLines = 0
        toastView.addSubview(toastMessageLabel)
        
        return toastView
    }
    
}
