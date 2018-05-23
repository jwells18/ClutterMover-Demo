//
//  DBJob.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import RealmSwift

class DBJob: Object{
    dynamic var objectId: String!
    dynamic var createdAt = Double()
    dynamic var updatedAt = Double()
    dynamic var name: String!
    dynamic var image: String!
    dynamic var customerId: String!
    dynamic var customerName: String!
    dynamic var customerPhone: String!
    dynamic var startDate = Double()
    dynamic var type: String!
    dynamic var status: String!
    dynamic var planType: String!
    dynamic var notes: String!
    dynamic var latitude = Double()
    dynamic var longitude = Double()
    dynamic var subThoroughfare: String! //Street Number
    dynamic var thoroughfare: String! //Street
    dynamic var locality: String! //City
    dynamic var administrativeArea: String! //State
    dynamic var country: String! //Country
    dynamic var postalCode: String!//Zip Code
    
    override static func primaryKey() -> String? {
        return jobPrimaryKey
    }
}
