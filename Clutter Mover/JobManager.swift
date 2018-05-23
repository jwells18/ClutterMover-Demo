//
//  JobManager.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import RealmSwift

class JobManager: NSObject{
    
    var ref: DatabaseReference!
    
    func loadJobs(uid: String, day: Date, completionHandler:@escaping (Results<DBJob>?) -> Void){
        //Load Jobs from Realm
        let realm = try! Realm()
        //TODO: Implemnt load jobs by day
        //let startOfDayTimestamp = day.startOfDay().timestamp()
        //let endOfDayTimestamp = day.endOfDay().timestamp()
        //let realmPredicate = NSPredicate(format: "startDate >= %lf AND startDate < %lf", startOfDayTimestamp, endOfDayTimestamp)
        let dbJobs = realm.objects(DBJob.self)//.filter(realmPredicate).sorted(byKeyPath: "startDate", ascending: false)
        completionHandler(dbJobs)
    }
}

extension JobManager{
    
    func lastUpdatedAt() -> Double{
        //Return all DBJobs from Realm and return most recent updatedAt date
        let realm = try! Realm()
        let job = realm.objects(DBJob.self).sorted(byKeyPath: "updatedAt", ascending: true).last
        if(job != nil){
            return (job?.updatedAt)!
        }
        else{
            return 0
        }
    }
}

extension JobManager{
    
    func createDataObservers(){
        //Create Database Observers
        if(Auth.auth().currentUser != nil){
            if (ref == nil){
                self.createObservers()
            }
        }
    }
    
    func createObservers(){
        let lastUpdatedAt = self.lastUpdatedAt()
        let employeeId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference(withPath: jobDatabase).child(employeeId!)
        let query: DatabaseQuery = ref.queryOrdered(byChild: "updatedAt").queryStarting(atValue: lastUpdatedAt+1)
        query.observe(.childAdded, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! NSDictionary
            if(rawData["updatedAt"] != nil){
                self.updateRealm(rawData: rawData)
            }
        })
        
        query.observe(.childChanged, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! NSDictionary
            if(rawData["updatedAt"] != nil){
                self.updateRealm(rawData: rawData)
            }
        })
        
        query.observe(.childRemoved, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! NSDictionary
            if(rawData["updatedAt"] != nil){
                self.deleteInRealm(rawData: rawData)
            }
        })
    }
    
    func updateRealm(rawData: NSDictionary){
        let realm = try! Realm()
        try! realm.write{
            realm.create(DBJob.self, value: rawData, update: true)
        }
    }
    
    func deleteInRealm(rawData: NSDictionary){
        let realm = try! Realm()
        let realmPredicate = NSPredicate(format: "objectId = %@", rawData["objectId"] as! String)
        let dbJob = realm.objects(DBJob.self).filter(realmPredicate).sorted(byKeyPath: "updatedAt", ascending: false)
        try! realm.write{
            realm.delete(dbJob)
        }
    }
}
