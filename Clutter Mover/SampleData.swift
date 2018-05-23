//
//  SampleData.swift
//  Clutter Mover
//
//  Created by Justin Wells on 5/10/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import Firebase

func createSampleEmployee(){
    let employee = Employee()
    employee.firstName = "James"
    employee.lastName = "Jackson"
    employee.email = "jjackson@clutter.com"
    employee.image = ""
    employee.team = "Chicago"
    employee.coach = "Bill Brooks"
    employee.birthday = createDate(string: "1995/04/13 00:00").timestamp()
    employee.mapSource = "noMapPreference"
    
    signUpEmployee(employee: employee, password: "password1")
}

func signUpEmployee(employee: Employee, password: String){
    //Sign Up Employee
    Auth.auth().createUser(withEmail: employee.email, password: password) { (user, error) in
        if(error == nil){
            //Create Employee Object
            employee.objectId = user?.uid
            let employeeManager = EmployeeManager()
            employeeManager.create(employee: employee, completionHandler: { (completed: Bool) in
                
            })
        }
        else{
            if let errCode = AuthErrorCode(rawValue: error!._code) {
                switch errCode {
                case .invalidEmail:
                    print("Error: Invalid Email")
                case .emailAlreadyInUse:
                    print("Error: Email Already in Use")
                case .weakPassword:
                    print("Password too weak")
                default:
                    break
                }
            }
        }
    }
}

func createSampleJob() -> Job{
    
    let sampleJob = Job()
    sampleJob.type = .pickup
    sampleJob.status = .notStarted
    sampleJob.customerName = "Sarah Smith"
    sampleJob.customerPhone = "4434210226"
    sampleJob.planType = .apartmentSize
    sampleJob.subThoroughfare = "325"
    sampleJob.thoroughfare = "Oak Crest Lane"
    sampleJob.locality = "Hollywood"
    sampleJob.administrativeArea = "CA"
    
    return sampleJob
}

func createSampleJobs() -> [Job]{
    
    var sampleJobs = [Job]()
    
    while sampleJobs.count < 16{
        sampleJobs.append(createSampleJob())
    }
    
    return sampleJobs
}

func uploadSampleJobs(){
    //Job Data Array
    var jobDataArray = [Dictionary<String, Any>]()
 
    //Create Sample Job Data
    let ref = Database.database().reference()
    for i in stride(from: 0, to: customerIds.count-1, by: 1) {
        var jobData = Dictionary<String, Any>()
        jobData["objectId"] = ref.childByAutoId().key
        jobData["createdAt"] = ServerValue.timestamp()
        jobData["updatedAt"] = ServerValue.timestamp()
        jobData["name"] = customerNames[i]
        jobData["image"] = ""
        jobData["customerId"] = customerIds[i]
        jobData["customerName"] = customerNames[i]
        jobData["customerPhone"] = customerPhones[i]
        jobData["startDate"] = createDate(string: startDates[i]).timestamp()
        jobData["type"] = types[i]
        jobData["status"] = JobStatus.notStarted.rawValue
        jobData["planType"] = planTypes[i]
        jobData["notes"] = notes[i]
        jobData["latitude"] = latitudes[i]
        jobData["longitude"] = longitudes[i]
        jobData["subThoroughfare"] = subThoroughfare[i] //Street Number
        jobData["thoroughfare"] = thoroughfare[i] //Street
        jobData["locality"] = locality[i] //City
        jobData["administrativeArea"] = "CA" //State
        jobData["country"] = "USA" //Country
        jobData["postalCode"] = postalCode[i] //Zip Code
        jobDataArray.append(jobData)
    }
    
    //Upload Job to Job Database
    for jobData in jobDataArray{
        let employeeManager = EmployeeManager()
        let currentDBEmployee = employeeManager.getCurrentDBEmployee()
        ref.child(jobDatabase).child((currentDBEmployee?.objectId)!).child(jobData["objectId"] as! String).setValue(jobData) { (error:Error?, DatabaseReference) in
            if((error) != nil){
                print("Error uploading job")
            }
        }
    }
}

//Sample Job Raw Data
let customerIds = ["cfU8ZkQa7ofmB57QpuDdmoBQulY2", "3EjwlVj0KAbRVXHyNM6ttz37F3J3", "UmBPIQgswuSu11kk6ucvsk4ZPVj1", "LEc8EfGo90NTGJbiWAmgGB6oRbH3", "vTI81usqgMXzWq5OG2pQD4tTrK32", "7N5pEu4YNVbn5lW5cs88yZAVbYC3", "2HYc4f1AJwaLzaPRd4KbThgWmPp1", "1FApVUTXyib66Vli1LH3HzEZGJf2"]
let customerNames = ["Sarah Smith", "Michelle Miller", "Barbara Brown", "Jessica Jones", "Daniel Davis", "Claire Clark", "Tim Thompson", "Ashley Anderson"]
let customerPhones = ["3108233032", "8448244224", "3105775090", "3103069348", "3103065150", "3103918919", "3233306104", "3104178138"]
let startDates = ["2018/05/21 08:00", "2018/05/21 09:45", "2018/05/20 10:45", "2018/05/20 11:30", "2018/05/20 12:45", "2018/05/20 14:00", "2018/05/20 14:45", "2018/05/20 15:30"]
let types = ["pickup", "pickup", "delivery", "delivery", "pickup", "delivery", "pickup", "pickup"]
let planTypes = ["apartmentSize", "walkInClosetSize", "studioSize", "apartmentSize", "garageSize", "smallClosetSize", "walkInClosetSize", "smallClosetSize"]
let notes = ["Glassware is already wrapped in newspaper. Please consider fragile.", "", "", "Third house from the mailboxes", "", "", "Freight elevator is available. Check in with guards for the key card.", ""]
let latitudes = [33.984924, 33.988826, 33.991862, 33.988276, 33.996328, 34.002357, 33.997037, 33.980695]
let longitudes = [-118.453612, -118.444412, -118.442039, -118.438535, -118.447570, -118.428815, -118.411809, -118.3974291]
let subThoroughfare = ["4333", "4108", "4055", "4241", "1506", "3940", "4620", "6300"]
let thoroughfare = ["Admiralty Way", "Del Rey Ave", "Redwood Ave", "Redwood Ave", "Venice Blvd # 303", "Grand View Blvd", "Slauson Ave", "Green Valley Cir"]
let locality = ["Marina Del Rey", "Marina Del Rey", "Marina Del Rey", "Los Angeles", "Venice", "Los Angeles", "Culver City", "Culver City"]
let administrativeArea = ["CA", "CA", "CA", "CA", "CA", "CA", "CA", "CA"]
let country = ["USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA"]
let postalCode = ["90292", "90292", "90066", "90066", "90291", "90066", "90230", "90230"]

