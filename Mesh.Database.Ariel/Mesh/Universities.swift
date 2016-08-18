//
//  Universities.swift
//  Mesh
//
//  Created by Ariel Bong on 8/10/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Universities {

    func createSchoolEvent(school: String) {
        let ref = FIRDatabase.database().reference()
        //ref.child(<#T##pathString: String##String#>)
        
    }
    
    func loadSchools() -> Array<[String: String]> {
        let url = NSBundle.mainBundle().URLForResource("universities.json", withExtension: "txt")
        let data = NSData(contentsOfURL: url!)
        var dictionary: [[String: String]] = []
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            dictionary = (object as? Array<[String: String]>)!
            return dictionary
            
        } catch {
            // Handle Error
        }
        return dictionary
    }
    
    func printUniversityNames() -> [String] {
        let dictionary = loadSchools()
        var universities: [String] = []
        for i in 0..<dictionary.count {
            guard let name = dictionary[i]["name"] else {break}
            universities.append(name)
        }
        
        return universities
    }
    
}