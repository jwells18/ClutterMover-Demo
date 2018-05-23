//
//  EmployeeManager.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import RealmSwift

class EmployeeManager: NSObject{
    var ref: DatabaseReference!
    
    func create(employee: Employee, completionHandler:@escaping (Bool) -> Void) {
        //Sign up New Employee
        let ref = Database.database().reference()
        var employeeData = Dictionary<String, Any>()
        employeeData["objectId"] = employee.objectId
        employeeData["createdAt"] = ServerValue.timestamp()
        employeeData["updatedAt"] = ServerValue.timestamp()
        employeeData["firstName"] = employee.firstName
        employeeData["lastName"] = employee.lastName
        employeeData["email"] = employee.email
        employeeData["image"] = employee.image
        employeeData["team"] = employee.team
        employeeData["coach"] = employee.coach
        employeeData["birthday"] = employee.birthday
        employeeData["mapSource"] = employee.mapSource
        ref.child(employeeDatabase).child(employee.objectId).child(employee.objectId).setValue(employeeData) { (error:Error?, DatabaseReference) in
            if((error) != nil){
                print("Error uploading employee")
            }
        }
    }
    
    func getCurrentDBEmployee() -> DBEmployee?{
        let employeeId = Auth.auth().currentUser?.uid
        return self.loadEmployee(uid: employeeId ?? "")
    }
    
    func updateEmployee(data: Dictionary<String, Any>) {
        let currentDBEmployee = self.getCurrentDBEmployee()
        self.ref = Database.database().reference().child(employeeDatabase).child((currentDBEmployee?.objectId)!).child((currentDBEmployee?.objectId)!)
        self.ref.updateChildValues(data)
    }
    
    func loadEmployee(uid: String) -> DBEmployee?{
        //Load Employee from Realm
        let realm = try! Realm()
        let realmPredicate = NSPredicate(format: "objectId = %@", uid)
        let dbEmployee = realm.objects(DBEmployee.self).filter(realmPredicate).sorted(byKeyPath: "updatedAt", ascending: false).first
        
        return dbEmployee
    }
    
    func signOutEmployee(){
        do{
            try Auth.auth().signOut()
            // Delete all objects from the realm
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension EmployeeManager{
    
    func createDataObservers(){
        //Create Database Observers
        if(Auth.auth().currentUser != nil){
            if (ref == nil){
                self.createObservers()
            }
        }
    }
    
    func createObservers(){
        let employeeId = Auth.auth().currentUser?.uid
        ref = Database.database().reference(withPath: employeeDatabase).child(employeeId!)
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! NSDictionary
            if(rawData["updatedAt"] != nil){
                self.updateRealm(rawData: rawData)
            }
        })
        
        ref.observe(.childChanged, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! NSDictionary
            if(rawData["updatedAt"] != nil){
                self.updateRealm(rawData: rawData)
            }
        })
        
        ref.observe(.childRemoved, with: { (snapshot) -> Void in
            let rawData = snapshot.value as! NSDictionary
            if(rawData["updatedAt"] != nil){
                self.deleteInRealm(rawData: rawData)
            }
        })
    }
    
    func updateRealm(rawData: NSDictionary){
        let realm = try! Realm()
        try! realm.write {
            realm.create(DBEmployee.self, value: rawData, update: true)
        }
    }
    
    func deleteInRealm(rawData: NSDictionary){
        let realm = try! Realm()
        let realmPredicate = NSPredicate(format: "objectId = %@", rawData["objectId"] as! String)
        let dbEmployee = realm.objects(DBEmployee.self).filter(realmPredicate).sorted(byKeyPath: "updatedAt", ascending: false)
        try! realm.write{
            realm.delete(dbEmployee)
        }
    }
}
