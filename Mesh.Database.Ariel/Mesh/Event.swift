//
//  Event.swift
//  Mesh
//
//  Created by Paa Adu on 8/2/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Foundation

class Event {
    var title: String
    var startTime: NSDate
    var endTime: NSDate
    var location: String
    var description: String
    var company: String

    
    init() {
        self.title = ""
        startTime = NSDate()
        endTime = NSDate()
        location = ""
        description = ""
        company = ""
        
    }
}