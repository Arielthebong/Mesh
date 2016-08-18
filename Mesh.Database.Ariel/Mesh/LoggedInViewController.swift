//
//  LoggedInViewController.swift
//  Mesh
//
//  Created by Paa Adu on 8/7/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit
import Firebase

class LoggedInViewController: UIViewController {
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var secEmail: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var saveProfileButton: UIButton!
    
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        text.text = "Logged in"
        //User is logged in ... do stuff
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func saveProfilePressed(sender: AnyObject) {
        
        let thisUser = User()
        //print(FIRAuth.auth()?.currentUser?.uid )
        //firstName.autocorrectionType = UITextAutocorrectionType.No
        print(firstName.text)
        thisUser.setUserId((FIRAuth.auth()?.currentUser?.uid)!)
        thisUser.setUserId(getCurrentUserId())
        thisUser.setFirstName(firstName.text!)
        thisUser.setLastName(lastName.text!)
        thisUser.setSchool(school.text!)
        
        saveProfile(thisUser)
    
        
    }
    

}
