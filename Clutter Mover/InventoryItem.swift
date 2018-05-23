//
//  InventoryItem.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation

class InventoryItem: NSObject{
    var objectId: String!
    var createdAt: Double!
    var updatedAt: Double!
    var userId: String!
    var username: String!
    var category: String!
    var caption: String!
    var image: String!
    var imageId: String!
    var tags: String!
    var status: ItemStatus!
    var employeeId: String!
    var jobId: String!
}

public enum ItemStatus: String{
    case available = "available"
    case requested = "requested"
    case returned = "returned"
    case inTransitToStorage = "inTransitToStorage"
    case inTransitToCustomer = "inTransitToCustomer"
}
