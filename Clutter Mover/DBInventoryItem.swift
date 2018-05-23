//
//  DBInventoryItem.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import RealmSwift

class DBInventoryItem: Object{
    dynamic var objectId: String!
    dynamic var createdAt = Double()
    dynamic var updatedAt = Double()
    dynamic var userId: String!
    dynamic var username: String!
    dynamic var category: String!
    dynamic var caption: String!
    dynamic var image: String!
    dynamic var imageId: String!
    dynamic var tags: String!
    dynamic var status: String!
    dynamic var employeeId: String!
    dynamic var jobId: String!
    
    override static func primaryKey() -> String? {
        return inventoryPrimaryKey
    }
}
