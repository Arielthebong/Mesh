//
//  User.swift
//  Mesh
//
//  Created by Paa Adu on 8/2/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

class User {
    var userId: String
    var firstName: String
    var lastName: String
    var secondaryEmail: String //school or company email
    var company: String
    var school: String
    
    init() {
        userId = ""
        firstName = "";
        lastName = "";
        secondaryEmail = "";
        company = "";
        school = "";
    }
    
   func setUserId(uID: String) {
        userId = uID
    }
    
    func setFirstName(name: String) {
        firstName = name
    }
    
    func setLastName(name: String) {
        lastName = name
    }
    
    func setCompany(name: String) {
        company = name
    }
    
    func setSchool(name: String) {
        school = name
    }
}