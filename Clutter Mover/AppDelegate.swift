//
//  AppDelegate.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import Toast_Swift
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Setup Firebase
        FirebaseApp.configure()
        
        //Set Default Screen
        let launchVC = LaunchController()
        self.setAppControllers(viewController: launchVC)
        
        //Setup Employee State Observer
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                //Setup Realm
                self.setupRealm(uid: Auth.auth().currentUser?.uid)
   
                //Setup Data Observers
                self.setupDataObservers()
                
                //Employee is signed in. Show Jobs Screen.
                self.setAppControllers(viewController: self.setupAppControllers())
            }
            else{
                //Employee is not signed in. Show Welcome Screen.
                self.setAppControllers(viewController:self.setupWelcomeController())
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        //Stop listening for Reachability
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        
        //Stop listening for Toasts
        ToastManager.shared.stopListening()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //Start listening for Reachability
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        //Start listening for Toasts
        ToastManager.shared.startListening()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //Database Functions
    func setupRealm(uid: String?){
        //Setup Realm
        let manager = RealmManager()
        manager.setDefaultRealmForEmployee(uid: uid!)
    }
    
    func setupDataObservers(){
        //Setup Data Observers
        let employeeManager = EmployeeManager()
        employeeManager.createDataObservers()
        let jobManager = JobManager()
        jobManager.createDataObservers()
    }
    
    //Setup App Controllers
    func setupWelcomeController() -> UIViewController{
        //Setup Welcome Controller
        let welcomeVC = WelcomeController()
        let navVC = NavigationController.init(rootViewController: welcomeVC)
        
        return navVC
    }
    
    func setupAppControllers() -> UIViewController{
        //Setup NavigationControllers for each tab
        let homeVC = HomeController()
        let navVC = NavigationController.init(rootViewController: homeVC)
        
        return navVC
    }
    
    func setAppControllers(viewController: UIViewController){
        //Set TabBarController as Window
        window?.rootViewController = viewController
    }
    
    //Reachability
    func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            let toastDict:[String: Any] = ["message": "noInternetConnection".localized()]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: presentToastNotification), object: nil, userInfo: toastDict)
        }
    }
}

