//
//  Constants.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Firebase

//View Dimensions
let screenBounds = UIScreen.main.bounds
let screenSize   = screenBounds.size
let w = screenSize.width
let h = screenSize.height

//UIObject Dimensions
let navigationHeight: CGFloat = 44.0
let statusBarHeight: CGFloat = 20.0
let navigationHeaderAndStatusbarHeight : CGFloat = navigationHeight + statusBarHeight
let tabBarHeight: CGFloat = 49.0

//Custom Colors
struct CLColor{
    static let primary = UIColorFromRGB(0x1EABA1)
    static let secondary = UIColorFromRGB(0xFF4508)
    static let tertiary = UIColorFromRGB(0x38435E)
    static let quaternary = UIColorFromRGB(0xBFE2E1)
    static let faintGray = UIColor(white: 0.95, alpha: 1)
}

public func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//Arrays
let jobHeaderTitles = ["details".localized(), "inventory".localized(), "map".localized()]
let jobDetailKeys = ["customerName", "address", "type", "plan", "startDate", "phone", "notes"]
let photoCaptureOptions = ["library".localized(), "photo".localized(), "video".localized()]
let settingsTitles0 = ["email", "birthday"]
let settingsImages0 = [UIImage(named: "email"), UIImage(named: "birthday")]
let settingsTitles1 = ["team", "coach"]
let settingsImages1 = [UIImage(named:"team"), UIImage(named:"coach")]
let settingsTitles2 = ["maps"]
let settingsImages2 = [UIImage(named: "maps")]
let settingsTitles3 = ["help", "logOut"]
let settingsImages3 = [UIImage(named: "help"), UIImage(named: "logOut")]
let inventoryItemDetailKeys = ["id#", "status", "category", "description", "jobId", "createdAt", "updatedAt"]

//Database Constants
var employeeDatabase = "Employee"
var employeePrimaryKey = "objectId"
var jobDatabase = "Job"
var jobPrimaryKey = "objectId"
var inventoryDatabase = "Inventory"
var inventoryPrimaryKey = "objectId"

//Other Constants
let customerServicePhoneNumber = 18885122208

//Notification Keys
var presentToastNotification = NSLocalizedString("PresentToastNotification", comment: "")
var refreshProfileVCNotification = NSLocalizedString("RefreshProfileVCNotification", comment: "")

//Other Functions
public func createDate(string: String) -> Date{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let date = formatter.date(from: string)
    return date!
}

extension Double{
    func dateValue() -> Date {
        let timeInterval: TimeInterval = self
        let date = Date.init(timeIntervalSince1970: timeInterval/1000)
        
        return date
    }
}

extension Date {
    func monthAndDay() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: self).capitalized
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self).capitalized
    }
    
    func timeLong() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self).capitalized
    }
    
    func startOfDay() -> Date {
        return NSCalendar.current.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.current.date(byAdding: components as DateComponents, to: self.startOfDay())!
    }
    
    func timestamp() -> Double{
        let timestamp = self.timeIntervalSince1970*1000
        return Double(timestamp)
    }
}


