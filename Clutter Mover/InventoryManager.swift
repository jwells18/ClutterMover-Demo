//
//  InventoryManager.swift
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
 
class InventoryManager: NSObject{
    
    var ref: DatabaseReference!
    
    func create(inventoryItem: InventoryItem, image: UIImage, completionHandler:@escaping (Bool, Dictionary<String, Any>) -> Void) {
        //Convert Image to Data
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        //Save Item Image
        let uuid = UUID().uuidString
        let imageFileName = String(format: "%@.jpeg", uuid)
        let storageRef = Storage.storage().reference()
        _ = storageRef.child(inventoryDatabase).child(inventoryItem.userId).child(imageFileName).putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL: URL = metadata.downloadURL()!
            //Create and Save new Pin
            self.ref = Database.database().reference()
            var itemData = Dictionary<String, Any>()
            itemData["objectId"] = self.ref.childByAutoId().key
            itemData["createdAt"] = ServerValue.timestamp()
            itemData["updatedAt"] = ServerValue.timestamp()
            itemData["userId"] = inventoryItem.userId
            itemData["username"] = inventoryItem.username
            itemData["category"] = inventoryItem.category
            itemData["caption"] = inventoryItem.caption
            itemData["image"] = downloadURL.absoluteString
            itemData["imageId"] = imageFileName
            itemData["tags"] = inventoryItem.tags
            itemData["status"] = inventoryItem.status.rawValue
            itemData["employeeId"] = inventoryItem.employeeId
            itemData["jobId"] = inventoryItem.jobId
            self.ref.child(inventoryDatabase).child(inventoryItem.userId).child(itemData["objectId"] as! String).setValue(itemData) { (error:Error?, DatabaseReference) in
                if((error) != nil){
                    completionHandler(false, itemData)
                }
                else{
                    completionHandler(true, itemData)
                }
            }
        }
    }
    
    func deleteInventoryItems(inventoryItems: [InventoryItem], completionHandler:@escaping (Error?) -> Void){
        for i in stride(from: 0, to: inventoryItems.count, by: 1) {
            let inventoryItem = inventoryItems[i]
            self.ref = Database.database().reference()
            self.ref.child(inventoryDatabase).child(inventoryItem.userId).child(inventoryItem.objectId).removeValue { (error: Error?, DatabaseReference) in
                if error == nil{
                    // Create a reference to the file to delete
                    let storageRef = Storage.storage().reference()
                    storageRef.child(inventoryDatabase).child(inventoryItem.userId).child(inventoryItem.imageId).delete { error in
                        if error != nil {
                            completionHandler(error)
                        } else {
                            completionHandler(error)
                        }
                    }
                }
                else{
                    completionHandler(error)
                }
            }
        }
    }

    func createInventoryItem(rawData: NSDictionary?) -> InventoryItem{
        let inventoryItem = InventoryItem()
        inventoryItem.objectId = rawData?.object(forKey: "objectId") as! String!
        inventoryItem.createdAt = rawData?.object(forKey: "createdAt") as! Double
        inventoryItem.updatedAt = rawData?.object(forKey: "updatedAt") as! Double
        inventoryItem.userId = rawData?.object(forKey: "userId") as! String!
        inventoryItem.username = rawData?.object(forKey: "username") as! String!
        inventoryItem.category = rawData?.object(forKey: "category") as! String!
        inventoryItem.caption = rawData?.object(forKey: "caption") as! String!
        inventoryItem.image = rawData?.object(forKey: "image") as! String!
        inventoryItem.imageId = rawData?.object(forKey: "imageId") as! String!
        inventoryItem.tags = rawData?.object(forKey: "tags") as! String!
        let status = rawData?.object(forKey: "status") as! String!
        inventoryItem.status = ItemStatus(rawValue: status!)
        inventoryItem.employeeId = rawData?.object(forKey: "employeeId") as! String!
        inventoryItem.jobId = rawData?.object(forKey: "jobId") as! String!
        
        return inventoryItem
    }
}


 

