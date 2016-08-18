//
//  MasterUser.swift
//  Mesh
//
//  Created by Ariel Bong on 8/10/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Foundation
import Firebase

class MasterUser: User {
    
    var verified: Bool!
    
    override init() {
        super.init()
        verified = false
    }
    

}
