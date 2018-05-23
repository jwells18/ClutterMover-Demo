//
//  DBEmployee.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/11/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import RealmSwift

class DBEmployee: Object{
    dynamic var objectId: String!
    dynamic var createdAt = Double()
    dynamic var updatedAt = Double()
    dynamic var firstName: String!
    dynamic var lastName: String!
    dynamic var email: String!
    dynamic var image: String!
    dynamic var team: String!
    dynamic var coach: String!
    dynamic var birthday = Double()
    dynamic var mapSource: String!
    
    override static func primaryKey() -> String? {
        return employeePrimaryKey
    }
}
