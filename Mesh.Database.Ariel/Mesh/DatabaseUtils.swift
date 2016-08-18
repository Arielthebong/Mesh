//
//  DatabaseUtils.swift
//  Mesh
//
//  Created by Paa Adu on 8/2/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Firebase
import UIKit 


//Save information about the current user
func saveProfile(user: User) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let profile = ["firstName": user.firstName,
                       "lastName": user.lastName,
                       "secondaryEmail": user.secondaryEmail,
                       "company": user.company,
                       "school": user.school,
                       "isMasterAccount": true] // ******change later******
        
        ref.child("users/\(userID)/profile").setValue(profile)
        if(user.school != "") {
            ref.child("schools/\(user.school)").child(userID).setValue(true)
        }
        
    }
}


//Returns bool based on whether current account is a Master Account

/*Asynchronous funch that returns bool based on whether current account is a Tech Account
 isMasterAccount() { (isMasterAccount) in
    if(isMasterAccount) {
        print("Yes, is Master account")
    }
 }
 */
func isMasterAccount(callback: (Bool) -> Void) {
    let ref = FIRDatabase.database().reference()
    let refMasterAccounts = ref.child("Master Accounts")
    var verified = false
    refMasterAccounts.observeSingleEventOfType(.Value, withBlock: { snapshot in
        
        if (snapshot.hasChild(getCurrentUserId()) && (FIRAuth.auth()?.currentUser?.emailVerified)!) {
            verified = true
        }
        callback(verified)
    })
}

/*Asynchronous funch that returns bool based on whether current account is a Tech Account
 isTechAccount() { (isTechAccount) in
    if(isTechAccount) {
        print("Yes, is tech account")
    }
 }
*/
func isTechAccount(callback: (Bool) -> Void) {
    var isTechAccount = false
    let refTechAccounts = FIRDatabase.database().reference().child("Tech Accounts")
    refTechAccounts.observeSingleEventOfType(.Value, withBlock: { snapshot in
        if (snapshot.hasChild(getCurrentUserId())) {
            isTechAccount = true
        }
        callback(isTechAccount)
    })
}


func getCurrentUserId() -> String {
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        return userID
    }
    return ""
}

//Request Master Account, uses company and userid for easy lookup
func requestMasterAccount(company: String) {
    let ref = FIRDatabase.database().reference()
    let requestsRef = ref.child("Requests")
    if let user = FIRAuth.auth()?.currentUser {
        let userInfo = ["Company": company,
                        "Email": user.email! as String]
        requestsRef.child(user.uid).setValue(userInfo)
    }

}

//Removes user from Requests and adds to Master Accounts 
func verifyMasterAccount(account: String) {
    let ref = FIRDatabase.database().reference()
   let company = ref.child("Requests/\(account)").valueForKey("Company")
    ref.child("Requests/\(account)").removeValue()
    ref.child("Master Accounts/\(account)").setValue(company)
    print("yaaaaa baby")
}

//Email verification
/*func verifyEmail()
    let currentUser = FIRAuth.auth()?.currentUser
currentUser?.sendEmailVerificationWithCompletion({
    
    })

}*/


//Save an event for the current user
func saveEvent(event: Event) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let eventDictionary = ["title": event.title,
                               "startTime": event.startTime.timeIntervalSince1970,
                               "endTime": event.endTime.timeIntervalSince1970,
                               "location": event.location,
                               "description": event.description]
        
        ref.child("users/\(userID)/events").childByAutoId().setValue(eventDictionary)
    }
}

//Save an event for another user, helper function for requestMasterAccount()
func saveEvent(event: Event, uID: String?) {
    let ref = FIRDatabase.database().reference()
    if let userID = uID {
        let eventDictionary = ["title": event.title,
                               "startTime": event.startTime.timeIntervalSince1970,
                               "endTime": event.endTime.timeIntervalSince1970,
                               "location": event.location,
                               "description": event.description]
        
        ref.child("users/\(userID)/events").childByAutoId().setValue(eventDictionary)
    }
}

//Add event notification for ever user of a school
func pushSchoolEvent(school: String, event: Event) {
    
    let ref = FIRDatabase.database().reference()
    let schoolRef = ref.child("schools/\(school)")
    schoolRef.observeSingleEventOfType(.Value, withBlock: {
        snapshot in
        for user in snapshot.children.allObjects as! [FIRDataSnapshot] {
            saveEvent(event, uID: user.key)
        }
    })
    
}


/* Asyncronous function to get all the events for the current user
 
 Sample Usage:
 getUserEvents() { (events) in
    for event in events {
        print("\n\(event.title)")
        print("\n\(event.description)")
    }
 }
 */
func getUserEvents(callback: ([Event]) -> Void){
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        ref.child("users/\(userID)/events").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            var events = [Event]()
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let event = Event()
                event.title = childSnapshot.value!["title"] as! String
                let startTime = childSnapshot.value!["startTime"] as! NSTimeInterval
                event.startTime = NSDate(timeIntervalSinceReferenceDate: startTime)
                let endTime = childSnapshot.value!["endTime"] as! NSTimeInterval
                event.endTime = NSDate(timeIntervalSinceReferenceDate: endTime)
                event.location = childSnapshot.value!["location"] as! String
                event.description = childSnapshot.value!["description"] as! String
                events.append(event)
            }
            callback(events);
        })
    }
}

//Adds a connection for the current user
func addConnection(user: User) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        let connection = ["id": user.userId]
        ref.child("users/\(userID)/connections").childByAutoId().setValue(connection)
    }
}

/* Asyncronous function to get all the connections that a user has
 
 Sample Usage:
 getConnections() { (users) in
    for user in users {
        print("\n\(user.firstName)")
    }
 }
 */
func getConnections(callback: ([User]) -> Void) {
    let ref = FIRDatabase.database().reference()
    if let userID = FIRAuth.auth()?.currentUser?.uid {
        ref.child("users/\(userID)/connections").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            var users = [User]()
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let user = User()
                user.userId = childSnapshot.value!["id"] as! String
                users.append(user)
            }
            callback(users);
        })
    }
}
/*Asynchronous function to get all Master Accounts
  
 (Only accessible by Tech Accounts, enforced by database)
 Sample Usage: 
 getMasterConnections() { (references) in
    for account in references 
    print(account.key)
    
 }
*/

func getMasterAccountRequests(callback: ([String:String]) -> Void) {
    var references = [String: String]()
    let ref = FIRDatabase.database().reference()
    if let _ = FIRAuth.auth()?.currentUser?.uid {
        ref.child("Requests").observeSingleEventOfType(.Value, withBlock: { snapshot in
            for user in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let company = user.value!["Company"] as! String
                print(company)
                let email = user.value!["Email"] as! String
                print(email)
                let info = company + " +  Email: " + email
                references[info] = user.key
            }
            callback(references)
        })
    }
}

/* Gets user Information from a given userId

 Sample Usage:
 getUserInformation(getCurrentUserId) { (user) in
    print("\(user.firstName)")
    print("\(user.lastName)")
 }
 */
func getUserInformation(userId: String, callback: (User) -> Void) {
    let ref = FIRDatabase.database().reference()
    ref.child("users/\(userId)/profile").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
        let user = User()
        user.userId = userId
        user.firstName = snapshot.value!["firstName"] as! String
        user.lastName = snapshot.value!["lastName"] as! String
        user.school = snapshot.value!["school"] as! String
        user.secondaryEmail = snapshot.value!["secondaryEmail"] as! String
        user.company = snapshot.value!["company"] as! String
        callback(user);
    })
}

func changeAccountEmail(newEmail: String) {
    let user = FIRAuth.auth()?.currentUser
    user?.updateEmail(newEmail, completion: { (callback) in
    })
}

func changePassword(newPassword: String) {
    let user = FIRAuth.auth()?.currentUser
    user?.updatePassword(newPassword, completion: {
        callback in
    })
}

func addSecondaryEmail(secondEmail: String) {
    let ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser
    ref.child("users/\(userID)/profile/secondaryEmail").setValue(secondEmail)
}

func signOUt() {
    let auth = FIRAuth.auth()
    
    do {
        try auth?.signOut()
    } catch let error {
        print(error)
    }
        
}

