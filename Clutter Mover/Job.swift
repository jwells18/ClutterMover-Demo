//
//  Job.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation

class Job: NSObject{
    var objectId: String!
    var createdAt: Double!
    var updatedAt: Double!
    var name: String!
    var image: String!
    var customerId: String!
    var customerName: String!
    var customerPhone: String!
    var startDate: Double!
    var type: JobType!
    var status: JobStatus!
    var planType: PlanType!
    var notes: String!
    var latitude: Double!
    var longitude: Double!
    var subThoroughfare: String! //Street Number
    var thoroughfare: String! //Street
    var locality: String! //City
    var administrativeArea: String! //State
    var country: String! //Country
    var postalCode: String!//Zip Code
}

public enum JobType: String{
    case delivery = "delivery"
    case pickup = "pickup"
}

public enum JobStatus: String{
    case notStarted = "notStarted"
    case inProgress = "inProgress"
    case completed = "completed"
}

public enum PlanType: String{
    case smallClosetSize = "smallClosetSize"
    case walkInClosetSize = "walkInClosetSize"
    case garageSize = "garageSize"
    case studioSize = "studioSize"
    case apartmentSize = "apartmentSize"
    case customSize = "customSize"
}
